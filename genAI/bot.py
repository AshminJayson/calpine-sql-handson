from openai import OpenAI
from pydantic import BaseModel

# Flight Data on server
available_flights = [
    {"from": "New York", "to": "Los Angeles"},
    {"from": "San Francisco", "to": "Chicago"},
    {"from": "Miami", "to": "Seattle"},
    {"from": "Los Angeles", "to": "New York"},
    {"from": "Boston", "to": "San Francisco"},
]


# API call to get available flights
def get_available_flights():
    return available_flights


# API call to make booking for flight
def book_flight(from_city: str, to_city: str, date: str):
    # In a real application, this would involve more complex logic
    return {
        "status": "success",
        "message": f"Flight booked from {from_city} to {to_city} on {date}."
    }


tools = [
    {
        "type": "function",
        "name": "get_available_flights",
        "description": "Get a list of available flights with their origin and destination cities.",
        "parameters": {
            "type": "object",
            "properties": {},
            "required": [],
        },
    },
    {
        "type": "function",
        "name": "book_flight",
        "description": "Book a flight from one city to another on a specific date.",
        "parameters": {
            "type": "object",
            "properties": {
                "from_city": {
                    "type": "string",
                    "description": "The city from which the flight departs.",
                },
                "to_city": {
                    "type": "string",
                    "description": "The city to which the flight arrives.",
                },
                "date": {
                    "type": "string",
                    "description": "The date of the flight in YYYY-MM-DD format.",
                },
            },
            "required": ["from_city", "to_city", "date"],
        },
    },
]

client = OpenAI(
    base_url="https://api.groq.com/openai/v1",
    api_key="KEY"
)


print("\n" * 2)
print("-" * 8 + " LOGS " + "-" * 8)
# print(messages)
