import yaml

# Load the list of servers
with open("apps/servers.yaml", "r") as f:
    servers = yaml.safe_load(f)

# Build scrape configs with hostnames as 'instance' labels
scrape_config = {
    "job_name": "node_exporters",
    "static_configs": [
        {
            "targets": [f"{server['ip']}:9100"],
            "labels": {"instance": server["hostname"]}
        } for server in servers
    ]
}

# Final Prometheus config
config = {
    "global": {"scrape_interval": "15s"},
    "rule_files": ["alert.rules.yml"],
    "scrape_configs": [scrape_config]
}

# Save the final prometheus.yml
with open("generated/prometheus.yml", "w") as f:
    yaml.dump(config, f)
