# import json
# import logging
# import random
# import time

# # Custom JSON log formatter
# class JsonFormatter(logging.Formatter):
#     def format(self, record):
#         log_entry = {
#             "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
#             "pipeline_stage": record.stage,
#             "pipeline_result": record.result
#         }
#         return json.dumps(log_entry)

# # Configure logging without the default INFO prefix
# logger = logging.getLogger("pipeline_logger")
# logger.setLevel(logging.INFO)

# # Ensure logs are written as raw JSON
# log_handler = logging.FileHandler("/var/log/pipeline.log")
# log_handler.setFormatter(JsonFormatter())

# logger.addHandler(log_handler)

# def log_pipeline_event(stage, result):
#     record = logging.LogRecord(
#         name="pipeline_logger",
#         level=logging.INFO,
#         pathname="simulate_pipeline.py",
#         lineno=0,
#         msg="",
#         args=(),
#         exc_info=None
#     )
#     record.stage = stage
#     record.result = result
#     logger.handle(record)

# # Pipeline simulation
# stages = ["deploy", "test", "monitor"]
# results = ["SUCCESS", "FAILURE"]

# while True:
#     stage = random.choice(stages)
#     result = random.choice(results)
#     log_pipeline_event(stage, result)
#     time.sleep(2)

import json
import logging
import random
import time

# Create a structured JSON logger
class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            "timestamp": self.formatTime(record, "%Y-%m-%dT%H:%M:%SZ"),
            "pipeline_stage": record.stage,
            "pipeline_result": record.result
        }
        return json.dumps(log_entry)

# Configure logging
logger = logging.getLogger("pipeline_logger")
logger.setLevel(logging.INFO)

handler = logging.FileHandler("/var/log/pipeline.log")
handler.setFormatter(JsonFormatter())
logger.addHandler(handler)

# Simulated pipeline logging
stages = ["deploy", "test", "monitor"]
results = ["SUCCESS", "FAILURE"]

while True:
    stage = random.choice(stages)
    result = random.choice(results)

    # Log with custom attributes
    record = logging.LogRecord(
        name="pipeline_logger",
        level=logging.INFO,
        pathname=__file__,
        lineno=0,
        msg="",
        args=(),
        exc_info=None
    )
    record.stage = stage
    record.result = result

    logger.handle(record)
    time.sleep(2)  # Adjust as needed
