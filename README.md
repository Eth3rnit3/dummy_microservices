# Dummy Microservices

## APIs

### Messages API

- POST /api/messages
  - body: { "message": "Hello World" }
```shell
curl -X POST http://localhost:3000/api/messages -H "Content-Type: application/json" -d '{"message": "Hello World"}'
```

### Notifications API

- POST /api/notifications
  - body: { "message": "Hello World", "email": "user@example.com" }

## Consumers

### Messages Consumer

- Consumes messages from queue operations.messages

### Notifications Consumer

- Consumes notifications from queue operations.notifications

## Producers

### Messages Producer

- Produces messages to queue operations.messages

## Workflow

1. User sends a message to the Messages API
2. Messages Producer puts the message in the queue operations.messages
3. Messages Consumer picks up the message from the queue and processes it
4. Message is appended to the database (messages.txt)
5. Message is sent to the user with the notifications API