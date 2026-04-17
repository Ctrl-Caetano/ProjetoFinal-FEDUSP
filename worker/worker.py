from datetime import datetime
from layer_raw import RawLayerProcessor
from layer_silver import SilverLayerProcessor
from log_utils import calculate_latency

def main():
    startDateTime = datetime.now()
    print("Worker starting...")
    
    raw_processor = RawLayerProcessor()
    silver_processor = SilverLayerProcessor()

    raw_processor.run()
    silver_processor.run()

    endDateTime = datetime.now()
    latency = calculate_latency(startDateTime, endDateTime)
    print(f"Worker Latency: {latency}")

if __name__ == "__main__":
    main()
