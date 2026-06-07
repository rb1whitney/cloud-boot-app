#!/usr/bin/env python3
import boto3
import time
import csv
import io
import argparse
import sys
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

def query_athena(query, database, s3_output):
    """Executes an Athena query and waits for completion."""
    client = boto3.client('athena')
    
    # Ensure s3_output ends with a slash
    if not s3_output.endswith('/'):
        s3_output += '/'
        
    try:
        response = client.start_query_execution(
            QueryString=query,
            QueryExecutionContext={'Database': database},
            ResultConfiguration={'OutputLocation': s3_output}
        )
        execution_id = response['QueryExecutionId']
        logger.info(f"Query started. Execution ID: {execution_id}")
        
        while True:
            status = client.get_query_execution(QueryExecutionId=execution_id)
            state = status['QueryExecution']['Status']['State']
            if state in ['SUCCEEDED', 'FAILED', 'CANCELLED']:
                break
            time.sleep(5)
            
        if state == 'SUCCEEDED':
            logger.info("Query succeeded.")
            # Athena appends the execution ID and .csv to the output location
            return execution_id, f"{s3_output}{execution_id}.csv"
        else:
            reason = status['QueryExecution']['Status'].get('StateChangeReason', 'Unknown reason')
            logger.error(f"Query {state}: {reason}")
            return None, None
    except Exception as e:
        logger.error(f"Error executing Athena query: {e}")
        return None, None

def parse_s3_results(s3_path):
    """Downloads and parses the CSV result from S3."""
    s3 = boto3.client('s3')
    if not s3_path.startswith('s3://'):
        logger.error(f"Invalid S3 path: {s3_path}")
        return []
    
    parts = s3_path[5:].split('/', 1)
    bucket = parts[0]
    key = parts[1]
    
    try:
        logger.info(f"Fetching results from {s3_path}...")
        response = s3.get_object(Bucket=bucket, Key=key)
        content = response['Body'].read().decode('utf-8')
        reader = csv.DictReader(io.StringIO(content))
        return list(reader)
    except Exception as e:
        logger.error(f"Error reading results from S3: {e}")
        return []

def analyze_costs(data):
    """Analyzes cost data, focusing on CUR schema fields."""
    logger.info("Analyzing cost data...")
    found_count = 0
    for row in data:
        # Handle potential case sensitivity in CSV headers
        resource_id = row.get('line_item_resource_id') or row.get('LINE_ITEM_RESOURCE_ID')
        cost = row.get('line_item_unblended_cost') or row.get('LINE_ITEM_UNBLENDED_COST')
        
        if resource_id and cost:
            logger.info(f"Resource: {resource_id} | Cost: ${cost}")
            found_count += 1
    
    if found_count == 0:
        logger.warning("No matching CUR fields found in results. Check query schema.")

def main():
    parser = argparse.ArgumentParser(description='FinOps Oracle - AWS Cost Analysis Tool')
    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    # Ingest command
    ingest_parser = subparsers.add_parser('ingest', help='Ingest cost data from Athena')
    ingest_parser.add_argument('--query', required=True, help='Athena SQL query')
    ingest_parser.add_argument('--database', required=True, help='Athena database')
    ingest_parser.add_argument('--output', required=True, help='S3 output location (e.g. s3://my-bucket/results/)')
    
    args = parser.parse_args()
    
    if args.command == 'ingest':
        exec_id, output_path = query_athena(args.query, args.database, args.output)
        if output_path:
            data = parse_s3_results(output_path)
            if data:
                analyze_costs(data)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
