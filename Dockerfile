# Use an official Python runtime as the base image
FROM continuumio/miniconda3

# Set the root user
USER root

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY conda/environment.yml .

# Create a Conda environment and install the dependencies
RUN conda env create --quiet --file environment.yml && \
    conda clean --all --force-pkgs-dirs --yes

# Activate the Conda environment
RUN echo "conda activate myenv" >> ~/.bashrc
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI application code
COPY app app

# Expose the FastAPI port
EXPOSE 8000

# Start the FastAPI application / Not recommended for Production
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Copy the server configuration file into the container
COPY gunicorn_server_config.py .

# Start Gunicorn when the container launches
CMD ["gunicorn", "app.main:app", "-c", "gunicorn_server_config.py"]
