import json

def handle_event(event, lambda_context):
  print("got {}\n".format(json.dumps(event)))
