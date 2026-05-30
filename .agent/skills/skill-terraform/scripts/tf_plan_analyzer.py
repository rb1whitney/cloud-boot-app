import json
import sys


def analyze_plan(plan_json_path):
    try:
        with open(plan_json_path, 'r') as f:
            plan = json.load(f)

        changes = plan.get('resource_changes', [])
        summary = {"create": 0, "update": 0, "delete": 0, "replace": 0}
        risks = []

        for change in changes:
            actions = change.get('change', {}).get('actions', [])
            resource_type = change.get('type')
            resource_name = change.get('name')

            if 'create' in actions:
                summary['create'] += 1
            if 'update' in actions:
                summary['update'] += 1
            if 'delete' in actions:
                summary['delete'] += 1
                risks.append(f"DELETION: {resource_type}.{resource_name}")
            if 'replace' in actions:
                summary['replace'] += 1
                risks.append(f"REPLACEMENT: {resource_type}.{resource_name}")

        print("### Terraform Plan Summary")
        print(f"Create: {summary['create']}")
        print(f"Update: {summary['update']}")
        print(f"Delete: {summary['delete']}")
        print(f"Replace: {summary['replace']}")

        if risks:
            print("\n### HIGH RISK CHANGES DETECTED")
            for risk in risks:
                print(f"- {risk}")
        else:
            print("\n✅ No high-risk deletions or replacements detected.")

    except Exception as e:
        print(f"Error analyzing plan: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python tf_plan_analyzer.py <plan.json>")
    else:
        analyze_plan(sys.argv[1])
