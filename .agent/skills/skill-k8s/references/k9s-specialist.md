# k9s Expert

You are a k9s power user. k9s is the standard terminal UI for Kubernetes cluster management. Use this skill when managing any EKS, GKE, or standard Kubernetes cluster interactively.

## Launch Commands

```bash
k9s                                  # Current kubeconfig context
k9s --context my-eks-cluster         # Specific context
k9s --namespace production           # Specific namespace
k9s --readonly                       # Safe mode  disables all destructive operations
k9s --kubeconfig ~/.kube/my-config   # Custom kubeconfig path
k9s --headless                       # No header bar (useful on small terminals)
```

## Navigation Protocol

k9s uses vim-inspired keybindings. Always start by understanding the current context:

1. Press `:` to enter command mode
2. Type `ctx` to see all available contexts  confirm you are on the right cluster
3. Type `ns` to select the target namespace
4. Type `pods` to view pods in that namespace

## Essential Command Mode Views

| Command | Resource |
|---|---|
| `pods` | All pods |
| `svc` | Services |
| `deploy` | Deployments |
| `sts` | StatefulSets |
| `ds` | DaemonSets |
| `ing` | Ingresses |
| `cm` | ConfigMaps |
| `secret` | Secrets (values redacted by default) |
| `ns` | Namespaces |
| `node` | Cluster nodes |
| `pv` | Persistent volumes |
| `pvc` | Persistent volume claims |
| `hpa` | Horizontal pod autoscalers |
| `ctx` | kubeconfig contexts |
| `rb` | RoleBindings |
| `crb` | ClusterRoleBindings |
| `ev` | Events (useful for debugging) |
| `sa` | Service accounts |

## Key Bindings Reference

| Key | Action |
|---|---|
| `:` | Enter command mode |
| `l` | Stream logs for selected pod |
| `s` | Shell exec into selected container |
| `d` | Describe selected resource (full YAML + events) |
| `e` | Edit resource in-place |
| `ctrl-d` | Delete selected resource (with confirmation) |
| `ctrl-k` | Force kill pod |
| `f` | Port-forward selected pod |
| `/` | Filter by name in current view |
| `0-9` | Switch namespace by index |
| `shift-f` | Show port-forward active sessions |
| `y` | View raw YAML of selected resource |
| `?` | Full keybinding help |
| `esc` | Go back or cancel |
| `q` | Quit |

## Diagnostic Workflows

### Pod Not Starting

```
:pods  select problem pod  d (describe)  scroll to Events section
```

Events section shows the root cause: ImagePullBackOff, OOMKilled, Unschedulable, etc.

### Stream Live Logs

```
:pods  select pod  l
```

In log view: `f` to toggle full-screen, `/` to filter log lines, `w` to toggle word wrap, `ctrl-s` to save logs to file.

### Exec Into Running Container

```
:pods  select pod  s
```

If the pod has multiple containers you will be prompted to select one. Requires a shell (`sh` or `bash`) in the container image. For minimal images use the busybox shell pod via `shift-s`.

### Port Forward to Local Machine

```
:pods  select pod  f  enter local port
```

This creates a tunnel from `localhost:<local-port>` to the pod's container port. The tunnel stays active until you quit k9s or press `ctrl-c` in the port-forward panel.

### Investigate Node Pressure

```
:node  select node  d (describe)
```

Look for `Conditions` section: `MemoryPressure`, `DiskPressure`, `PIDPressure`. Check `Allocatable` vs `Capacity` for resource exhaustion.

### View RBAC for a Service Account

```
:sa  select service account  enter  shows associated role bindings
:rb  filter by namespace  d (describe) to see permissions
```

## Configuration

k9s config at `~/.config/k9s/config.yaml`:

```yaml
k9s:
  refreshRate: 2
  readOnly: false        # Set true on production clusters
  ui:
    enableMouse: true
    reactive: false      # True = refresh on every keypress (CPU intensive)
  shellPod:
    image: busybox:latest
    namespace: default
    limits:
      cpu: 100m
      memory: 100Mi
```

Custom aliases at `~/.config/k9s/aliases.yaml`:

```yaml
aliases:
  dp: deployments
  svc: services
  ing: ingresses
```

Custom hotkeys at `~/.config/k9s/hotkeys.yaml`:

```yaml
hotKeys:
  shift-0:
    shortCut: Shift-0
    description: View all namespaces
    command: pods
    description: All pods across namespaces
```

## Skins (Optional)

Download community skins from https://github.com/derailed/k9s/tree/master/skins and place in `~/.config/k9s/skins/`. Reference in config:

```yaml
k9s:
  ui:
    skin: dracula
```

## Common Issues

**k9s shows no resources**: Check you are in the right namespace. Press `0` to view all namespaces. Check your kubeconfig context with `:ctx`.

**Shell exec fails**: The container image may not have a shell. Use `shift-s` to launch a busybox shell pod on the same node.

**Logs not streaming**: The pod may be in `Pending` or `Completed` state  logs only stream from running containers. Check pod status with `d` (describe).

**Port forward stops unexpectedly**: Check network connectivity and ensure the pod is still running. Port forwards terminate when the pod restarts.

**403 Forbidden on resources**: Your service account or kubeconfig user lacks RBAC permissions. Check with `:rb` and `:crb` to inspect role bindings for your user.