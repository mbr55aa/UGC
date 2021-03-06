"""Настройки логера."""

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'console': {
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        },
        'json': {
            'class': 'pythonjsonlogger.jsonlogger.JsonFormatter',
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        },
    },
    'handlers': {
        'console': {
            'formatter': 'console',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',
        },
        'file': {
            'formatter': 'json',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': 'logs/kafka_writer.log',
            'mode': 'a',
            'delay': '1',
            'maxBytes': 1000000,
            'backupCount': 3,
        },
    },
    'loggers': {
        'kafka': {
            'level': 'ERROR',
            'handlers': [
                'console',
                'file',
            ],
        },
    },
    'root': {
        'level': 'INFO',
        'handlers': [
            'console',
        ],
    },
}
