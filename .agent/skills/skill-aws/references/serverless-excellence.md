# AWS Reference: Serverless Excellence & Event-Driven Design

Following the AWS Well-Architected Framework: Operational Excellence Pillar.

## 1. Lambda Best Practices
- **Single Responsibility**: Each function should perform one specific task.
- **Size & Performance**: Optimize memory allocation (Memory also scales CPU). Use Provisioned Concurrency for latency-sensitive APIs.
- **Statelessness**: Store state in DynamoDB or ElastiCache, never on the local filesystem.
- **Error Handling**: Use Lambda Destinations for success/failure callbacks.

## 2. EventBridge & Orchestration
- **Event-Driven Architecture (EDA)**: Use EventBridge as the central bus to decouple microservices.
- **Pipes**: Use EventBridge Pipes for point-to-point integration between producers (DynamoDB, SQS) and consumers.
- **Step Functions**: The preferred way to manage complex, long-running workflows and retry logic. Avoid "Lambda-to-Lambda" synchronous calls.

## 3. Asynchronous Messaging
- **SQS (Simple Queue Service)**: Buffering and decoupling at scale. Use Dead Letter Queues (DLQ) for failed message handling.
- **SNS (Simple Notification Service)**: Fan-out patterns for broadcasting to multiple consumers.

## 4. Observability & CI/CD
- **CloudWatch Insights**: Querying logs across many functions for fast troubleshooting.
- **AWS X-Ray**: Distributed tracing to identify bottlenecks in event-driven flows.
- **SAM / CDK / Terraform**: Using purpose-built IaC for serverless deployments.