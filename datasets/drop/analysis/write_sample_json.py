import os
import json

input_json="./resources/data/drop/date_subset/drop_dataset_train.json"
output_json="./semqa/tests/data/drop/date/drop.json"

num_of_passages_in_out = 3

with open(input_json, 'r') as f:
    dataset = json.load(f)

output_dict = {}

for passage_id, passage_info in dataset.items():
    output_dict[passage_id] = passage_info
    num_of_passages_in_out -= 1
    if num_of_passages_in_out <= 0:
        break


with open(output_json, 'w') as outf:
    json.dump(output_dict, outf, indent=4)


print(f"Sample Json written in: {output_json}")


