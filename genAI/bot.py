import json
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
    print(f"Booking flight from {from_city} to {to_city} on {date}")

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
)


input_list = []
skip_input = False

while True:
    if not skip_input:
        user_input = input("User: ")
        if user_input.lower() in ["exit", "quit"]:
            break

        input_list.append({"role": "user", "content": user_input})

    skip_input = False
    response = client.responses.create(
        model="openai/gpt-oss-20b",
        input=input_list,
        tools=tools,
    )

    input_list += response.output

    for item in response.output:
        if item.type == "function_call":
            function_name = item.name
            function_args = json.loads(item.arguments)

            if function_name == "get_available_flights":
                flight_data = get_available_flights()
                input_list.append({
                    "type": "function_call_output",
                    "call_id": item.call_id,
                    "output": str(flight_data),
                })
            elif function_name == "book_flight":
                booking_response = book_flight(
                    from_city=function_args["from_city"],
                    to_city=function_args["to_city"],
                    date=function_args["date"]
                )
                input_list.append({
                    "type": "function_call_output",
                    "call_id": item.call_id,
                    "output": str(booking_response),
                })

    # print(input_list)
    # If last item is dict
    if isinstance(input_list[-1], dict):
        skip_input = True
        continue

    print("Assistant:", input_list[-1].content[0].text)


print("\n" * 2)
print("-" * 8 + " LOGS " + "-" * 8)
print(input_list)
