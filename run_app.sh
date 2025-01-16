#!/bin/bash --login  

#SBATCH --job-name=flask_server  # Name the job
#SBATCH --account=interns202410-gpu  # Use your own project and the -gpu suffix
#SBATCH --partition=gpu  # Ensure partition is gpu
#SBATCH --nodes=1  # 1 node 
#SBATCH --gpus-per-node=1  # 1 GPU per node
#SBATCH --time=01:00:00  # Set time needed

# --------------------------
# Load the needed modules
module list

# --------------------------
# Set the port for the SSH tunnel
# This part of the script uses a loop to search for available ports on the node;
# this will allow multiple instances of GUI servers to be run from the same host node
port="8000" #should be the same with the port in app.py
pfound="0"
while [ $port -lt 65535 ]; do
  check=$(ss -tuna | awk '{print $4}' | grep ":$port *")
  if [ "$check" == "" ]; then
    pfound="1"
    break
  fi
  : $((++port))
done

if [ $pfound -eq 0 ]; then
  echo "No available communication port found to establish the SSH tunnel."
  echo "Try again later. Exiting."
  exit
else
  echo "Using port=${port} for the Flask server."
fi

# --------------------------
# Some paths
VENV_PATH=$MYSOFTWARE/tempenv3/bin/activate
PYTHON_SCRIPT=$MYSCRATCH/flask-app/app.py

# --------------------------
# Setup instructions for SSH tunneling
host=$(hostname)
echo "*****************************************************"
echo "Setup - from your laptop, in a separate local terminal window run:"
echo "ssh -N -f -L ${port}:${host}:${port} $USER@setonix.pawsey.org.au"
echo "*****************************************************"
echo ""

# --------------------------
# Run the Flask application
cd $MYSCRATCH/flask-app
echo "Current working directory: $(pwd)"
echo ""
echo "*****************************************************"
echo "To access the web server, open these URLs in a browser"
echo "http://127.0.0.1:${port}"
echo "or http://localhost:${port}"
echo "*****************************************************"
echo ""

srun -N 1 -n 1 -c 8 --gres=gpu:1 bash -c "
  source $VENV_PATH && \
  python $PYTHON_SCRIPT --host=0.0.0.0 --port=${port}
"
