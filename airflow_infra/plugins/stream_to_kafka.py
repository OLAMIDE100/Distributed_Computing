import requests
import json
import time
from faker import Faker
from kafka import KafkaProducer
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM



fake = Faker(['en_US'])
model = AutoModelForSeq2SeqLM.from_pretrained("google/flan-t5-small")
tokenizer = AutoTokenizer.from_pretrained("google/flan-t5-small")



def sentiment_analysis(input_text):
    prompt = f"sentiment of the text: {input_text}"
    input = tokenizer(prompt, return_tensors="pt")
    output = model.generate(**input)
    output_text = tokenizer.decode(output[0], skip_special_tokens=True)
    return output_text


def start_streaming():
    """
    Writes the API data every 10 seconds to Kafka topic random_names
    """
    producer = KafkaProducer(bootstrap_servers=['kafka-broker-1:19092', 'kafka-broker-2:19093'])
        

    end_time = time.time() + 60 # the script will run for 2 minutes
    while True:
        if time.time() > end_time:
            break

        kafka_data = {}
        kafka_data["id"] = int(time.time() * 100000)
        sentence = fake.sentence()
        kafka_data["sentence"] = sentence
        kafka_data["sentimental_analysis"] = sentiment_analysis(sentence)
        producer.send("sentences", json.dumps(kafka_data).encode('utf-8'))
        

        time.sleep(0.01)


if __name__ == "__main__":
    start_streaming()