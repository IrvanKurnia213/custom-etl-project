if ! docker network ls | grep -q "elt_network"; then
  echo "Create elt_network"
  docker network create elt_network
else
  echo "elt_network found"
fi

docker compose up init-airflow

sleep 5

docker compose up -d

sleep 5


# Check if abctl is installed
if ! command -v abctl &> /dev/null
then
    echo "abctl not found. Installing..."

    # Download abctl binary
    curl -sSL https://github.com/airbytehq/airbyte/releases/download/0.39.11-alpha/abctl-linux-x86_64 -o /usr/local/bin/abctl

    # Make it executable
    chmod +x /usr/local/bin/abctl

    # Add abctl to PATH (if not already in PATH)
    if ! echo $PATH | grep -q "/usr/local/bin"; then
        export PATH=$PATH:/usr/local/bin
    fi

    echo "abctl installed successfully."
else
    echo "abctl is already installed."
fi

# Install Airbyte using abctl (this will automatically configure everything)
echo "Running abctl local install..."

abctl local install