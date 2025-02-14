# Port Forwarding on Setonix

A Flask web server setup for running GPU-accelerated web applications on Pawsey's Setonix supercomputer with local browser access through SSH tunneling.

## Prerequisites

- Access to Pawsey's Setonix supercomputer
- SSH client on your local machine
- Python virtual environment on Setonix with Flask installed

## Setup & Installation

1. Clone this repository to your `$MYSCRATCH` directory on Setonix:

```bash
cd $MYSCRATCH
git clone <repository-url> flask-app
```

2. Ensure you have a Python virtual environment with Flask:

```bash
cd $MYSOFTWARE
python -m venv tempenv3
source tempenv3/bin/activate
pip install flask

```

## Usage

1. Submit the job:

```bash
cd $MYSCRATCH/flask-app
sbatch run_app.sh
```

2. Check the job output file (slurm-\*.out) for the SSH tunneling command. It will look like:

```bash
ssh -N -f -L <port>:<hostname>:<port> <username>@setonix.pawsey.org.au
```

3. Run the SSH tunnel command on your local machine

4. Access the web server through your browser at:

- `http://localhost:<port>`
- `http://127.0.0.1:<port>`

## Available Routes

- `/` - Welcome page
- `/simulator_home` - Simulator home page

## Technical Details

- Uses SLURM's GPU partition
- Automatically finds available ports (starting from 8000)
- Requests 1 GPU and 8 CPU cores
- Default runtime: 1 hour

## Troubleshooting

1. If the port is already in use:

   - The script will automatically try the next available port
   - Check the job output file for the actual port being used

2. If the SSH tunnel fails:
   - Ensure no existing tunnels are using the same port
   - Kill existing tunnels if necessary: `ps aux | grep ssh`

## Resource Allocation

The job requests:

- 1 node
- 1 GPU
- 8 CPU cores
- 1 hour runtime

## Important Notes

1. Port Configuration:

   - The script automatically searches for available ports starting from 8000
   - Make sure to update the port in `app.py` to match the port used in `run_app.sh`

2. Virtual Environment:
   - The script expects the virtual environment at `$MYSOFTWARE/tempenv3`
   - Flask application should be located at `$MYSCRATCH/flask-app/app.py`
