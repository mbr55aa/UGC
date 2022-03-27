"""class KafkaReader."""

import logging
from logging import config as logger_config
from time import sleep

from kafka import KafkaConsumer

from kafka_rw.config.config import Config
from kafka_rw.logger.logger_config import LOGGING

logger_config.dictConfig(LOGGING)
logger = logging.getLogger(__name__)

config = Config.parse_file('config/config.json')


class KafkaReader:
    """Класс для описания функций чтения из Kafka."""

    def __init__(self, topics: list, host: str, port: int, timeout: float):
        """
        Функция инициализации экземпляра класса.

        Args:
            topics: Топики.
            host: Хост kafka.
            port: Порт kafka.
            timeout: Максимальное время жизни инстанса.
        """
        self.topics = topics
        self.host = host
        self.port = port
        self.timeout = timeout

    def read(self):
        """."""
        for topic in self.topics:
            logger.info(f'Start to read {topic}')

            consumer = KafkaConsumer(
                topic,
                bootstrap_servers=[f'{self.host}:{self.port}'],
                auto_offset_reset='earliest',
                group_id='echo-messages-to-stdout',
                consumer_timeout_ms=self.timeout,
            )

            for message in consumer:
                logger.info(f'{topic} {message.key}:{message.value}')

            logger.info(f'Close {topic} consumer')
            consumer.close()


if __name__ == '__main__':
    try:
        reader = KafkaReader(
            config.common.topics,
            config.kafka.host,
            config.kafka.port,
            config.reader.consumer_timeout_ms,
        )
        while True:
            reader.read()
            sleeping_time = config.reader.sleeping_time
            logger.info(f'Sleeping for {sleeping_time} seconds')
            sleep(sleeping_time)
    except KeyboardInterrupt:
        logger.info('Program is stopped')
