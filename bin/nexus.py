import os
import shutil
import sys

def sync():
    # Use absolute path for the workspace root to prevent traversal
    workspace_root = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
    os.chdir(workspace_root)
    
    master_vault = ".agent"
    vendors = {
        ".gemini": {"agents": "dir", "skills": "dir"},
        ".claude": {"agents": "file", "skills": "file"},
        ".github": {"agents": "copilot", "skills": "copilot"}
    }

    print(f"--- Nexus Sync Starting (ACS 2026) ---")
    print(f"Root: {workspace_root}")

    for vendor, types in vendors.items():
        vendor_path = os.path.abspath(os.path.join(workspace_root, vendor))
        
        # Security Guardrail: Ensure vendor path is inside workspace
        if not vendor_path.startswith(workspace_root):
            print(f"ERROR: Dangerous vendor path detected: {vendor}")
            continue

        for category in ["agents", "skills"]:
            target_dir = os.path.join(vendor_path, category)
            
            # Clean up target directory if it exists
            if os.path.exists(target_dir):
                # Ensure we are not deleting something outside the vendor folder
                if os.path.islink(target_dir):
                    os.unlink(target_dir)
                elif os.path.isdir(target_dir):
                    shutil.rmtree(target_dir)
            
            os.makedirs(target_dir, exist_ok=True)

            source_base = os.path.join(workspace_root, master_vault, category)
            if not os.path.exists(source_base):
                continue

            for item in os.listdir(source_base):
                source_path = os.path.join(source_base, item)
                
                if types[category] == "dir":
                    # Gemini style: Symlink the whole directory
                    link_name = item
                    dest_link = os.path.join(target_dir, link_name)
                    rel_source = os.path.relpath(source_path, target_dir)
                    os.symlink(rel_source, dest_link)
                    print(f"Linked {vendor}/{category}/{link_name} -> {item}")
                
                elif types[category] in ["file", "copilot"]:
                    # Claude/Copilot style: link the SYSTEM.md/SKILL.md as a file
                    content_file = "SYSTEM.md" if category == "agents" else "SKILL.md"
                    real_source = os.path.join(source_path, content_file)
                    
                    if not os.path.exists(real_source):
                        continue
                        
                    ext = ".agent.md" if types[category] == "copilot" and category == "agents" else ".md"
                    link_name = f"{item}{ext}"
                    dest_link = os.path.join(target_dir, link_name)
                    
                    rel_source = os.path.relpath(real_source, target_dir)
                    os.symlink(rel_source, dest_link)
                    print(f"Linked {vendor}/{category}/{link_name} -> {item}/{content_file}")

    print(f"--- Nexus Sync Complete ---")

if __name__ == "__main__":
    sync()
