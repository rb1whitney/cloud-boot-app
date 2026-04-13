# Ansible Style Guide

Standards for writing Ansible playbooks, roles, and tasks following Red Hat official conventions and community best practices.

**References:** [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html) | [Ansible Lint Rules](https://ansible.readthedocs.io/projects/lint/) | [Red Hat Ansible Style Guide](https://redhat-cop.github.io/automation-good-practices/)

## Directory Structure

```
ansible/
├── inventories/
│   ├── production/
│   │   ├── hosts.yml         # Inventory file
│   │   └── group_vars/
│   │       ├── all.yml       # Variables for all hosts
│   │       └── web.yml       # Variables for web group
│   └── staging/
│       └── hosts.yml
├── roles/
│   └── nginx/
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── templates/
│       │   └── nginx.conf.j2
│       ├── files/
│       ├── vars/
│       │   └── main.yml
│       ├── defaults/
│       │   └── main.yml      # Low-priority defaults — always override-able
│       ├── meta/
│       │   └── main.yml      # Dependencies
│       └── README.md
├── playbooks/
│   ├── site.yml              # Master playbook — include all roles
│   ├── web.yml               # Web tier playbook
│   └── database.yml
├── group_vars/
│   └── all/
│       ├── vars.yml
│       └── vault.yml         # Encrypted with ansible-vault
├── host_vars/
├── ansible.cfg
└── requirements.yml          # Galaxy role dependencies
```

## Playbook Conventions

```yaml
---
# playbooks/web.yml
- name: Configure web tier                # name is REQUIRED on every play
  hosts: web
  become: true
  become_method: sudo
  gather_facts: true

  roles:
    - role: common
    - role: nginx
      vars:
        nginx_port: 443
```

**Rules**:
- Every play must have `name`
- Every task must have `name`
- Use `become: true` at play level, not task level (unless a single task needs it)
- Never use `hosts: all` in production playbooks — always name specific groups

## Task Naming Standards

```yaml
# Bad — vague, no context
- name: Run script
  shell: /opt/setup.sh

# Bad — missing name entirely
- copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf

# Good — imperative verb phrase describing the change
- name: Deploy nginx configuration from template
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
  notify: Restart nginx
```

## Module Usage Rules

Always use **fully qualified collection names (FQCN)** for all modules:

```yaml
# Bad — short names are deprecated and ambiguous
- copy:
- template:
- service:
- yum:

# Good — FQCN
- ansible.builtin.copy:
- ansible.builtin.template:
- ansible.builtin.service:
- ansible.builtin.dnf:
- amazon.aws.ec2_instance:
- community.kubernetes.k8s:
```

## File, Template, and Copy Conventions

```yaml
# Copy static files
- name: Deploy sudoers configuration
  ansible.builtin.copy:
    src: sudoers.d/myapp          # Relative to role files/
    dest: /etc/sudoers.d/myapp
    owner: root
    group: root
    mode: "0440"                  # Always quote octal modes
    validate: /usr/sbin/visudo -cf %s

# Deploy templates
- name: Deploy nginx virtual host configuration
  ansible.builtin.template:
    src: vhost.conf.j2
    dest: "/etc/nginx/conf.d/{{ item.name }}.conf"
    owner: root
    group: root
    mode: "0644"
  loop: "{{ nginx_vhosts }}"
  notify: Reload nginx

# Fetch files from remote (avoid — prefer copy)
- name: Retrieve application logs for inspection
  ansible.builtin.fetch:
    src: /var/log/myapp/app.log
    dest: /tmp/fetched/
    flat: true
```

## Variables and Precedence

Variables in order of increasing precedence (higher overrides lower):

| Level | File | Use For |
|---|---|---|
| Role defaults | `roles/{role}/defaults/main.yml` | Safe defaults users can override |
| Group vars | `group_vars/{group}.yml` | Environment-specific values |
| Host vars | `host_vars/{host}.yml` | Host-specific overrides |
| Playbook vars | Play-level `vars:` | Task-specific temporary values |
| Extra vars | `-e key=value` | CI/CD pipeline injection only |

```yaml
# defaults/main.yml — always document defaults
nginx_user: www-data
nginx_worker_processes: auto
nginx_worker_connections: 1024
nginx_port: 80
nginx_enable_ssl: false
```

## Handlers

```yaml
# handlers/main.yml
---
- name: Restart nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
  listen: Restart nginx

- name: Reload nginx
  ansible.builtin.service:
    name: nginx
    state: reloaded
  listen: Reload nginx

- name: Reload systemd
  ansible.builtin.systemd:
    daemon_reload: true
  listen: Reload systemd
```

**Rules**:
- Handler names must match their `notify` strings exactly
- Use `listen` for handler aliases (allows multiple tasks to trigger the same handler)
- Handlers only run once at the end of a play, even if notified multiple times

## Jinja2 Template Conventions

```jinja2
{# nginx.conf.j2 #}
{# Always add a comment indicating this is a managed file #}
# This file is managed by Ansible. Manual changes will be overwritten.

user {{ nginx_user }};
worker_processes {{ nginx_worker_processes }};

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    {% for vhost in nginx_vhosts %}
    server {
        listen {{ nginx_port }};
        server_name {{ vhost.name }};

        {% if vhost.enable_ssl | default(false) %}
        ssl_certificate     {{ vhost.ssl_cert }};
        ssl_certificate_key {{ vhost.ssl_key }};
        {% endif %}
    }
    {% endfor %}
}
```

## Secrets with Ansible Vault

```bash
# Encrypt entire file
ansible-vault encrypt group_vars/production/vault.yml

# Encrypt a single string value for inline use
ansible-vault encrypt_string 'my-secret-password' --name 'db_password'

# Reference in vars file
# group_vars/production/vault.yml (encrypted)
vault_db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...hex...
```

Never store unencrypted secrets in:
- `group_vars/` files not in vault
- `host_vars/` files
- Playbook `vars:` blocks
- Role `defaults/` or `vars/`

## `changed_when` and `when` Rules

```yaml
# Always set changed_when on shell/command tasks
- name: Check if application is already initialized
  ansible.builtin.command: /opt/myapp/bin/check-init
  register: init_check
  changed_when: false           # Read-only — never changes state
  failed_when: init_check.rc > 1

- name: Initialize application database
  ansible.builtin.command: /opt/myapp/bin/init-db
  changed_when: "'already initialized' not in init_result.stdout"
  register: init_result
  when: init_check.rc == 1

# Use when conditions for idempotency
- name: Install pip packages
  ansible.builtin.pip:
    name: "{{ item }}"
    state: present
  loop: "{{ pip_packages }}"
  when: pip_packages | length > 0
```

## ansible.cfg Conventions

```ini
[defaults]
inventory          = inventories/production
roles_path         = roles
collections_paths  = ~/.ansible/collections
host_key_checking  = True
stdout_callback    = yaml
stderr_callback    = yaml
bin_ansible_callbacks = True
callback_whitelist = profile_tasks, timer

[ssh_connection]
pipelining         = True    # Significant performance improvement
ssh_args           = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=yes
control_path       = %(directory)s/%%h-%%r

[privilege_escalation]
become             = False   # Opt-in at play level, not global
become_method      = sudo
become_ask_pass    = False
```

## Code Review Checklist

- [ ] Every play has `name`
- [ ] Every task has `name` — present tense imperative verb phrase
- [ ] All modules use FQCN
- [ ] All file permissions quoted as strings (`"0644"` not `0644`)
- [ ] No unencrypted secrets — all sensitive values in vault
- [ ] `changed_when: false` on all read-only `command`/`shell` tasks
- [ ] `ansible-lint --profile production` passes clean
- [ ] Handlers use `listen` aliases
- [ ] Templates include managed-by comment on first line
- [ ] `requirements.yml` lists all Galaxy role dependencies with pinned versions

---

*Based on: [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html) and [Red Hat Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/)*
