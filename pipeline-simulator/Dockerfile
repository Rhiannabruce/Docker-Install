FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3 python3-pip
COPY simulate_pipeline.py /simulate_pipeline.py
CMD ["python3", "/simulate_pipeline.py"]
