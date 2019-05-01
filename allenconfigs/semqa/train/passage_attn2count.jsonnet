local utils = import 'utils.libsonnet';


{
  "dataset_reader": {
      "type": "passage_attn2count_reader",
      "min_passage_length": 200,
      "max_passage_length": 400,
      "max_span_length": 10,
      "num_training_samples": 2000,
      "normalized": utils.boolparser(std.extVar("NORM")),
      "withnoise": utils.boolparser(std.extVar("NOISE")),
  },

  "train_data_path": std.extVar("TRAINING_DATA_FILE"),
  "validation_data_path": std.extVar("VAL_DATA_FILE"),

  "model": {
      "type": "drop_pattn2count",

      "passage_attention_to_count": {
          "type": std.extVar("TYPE"),
          "input_size": utils.parse_number(std.extVar("ISIZE")),
          "hidden_size": utils.parse_number(std.extVar("HSIZE")),
          "num_layers": utils.parse_number(std.extVar("NL")),
          "bidirectional": true,
          "dropout": 0.2
      },
  },

  "iterator": {
    "type": "basic",
    "batch_size": std.extVar("BS"),
    "max_instances_in_memory": std.extVar("BS")
  },

  "trainer": {
      "num_serialized_models_to_keep": 1,
      "grad_norm": 5,
      "patience": 5,
      "cuda_device": utils.parse_number(std.extVar("GPU")),
      "num_epochs": utils.parse_number(std.extVar("EPOCHS")),
      "shuffle": true,
      "optimizer": {
          "type": "adam",
          "lr": 0.001,
          "betas": [
              0.8,
              0.999
          ],
          "eps": 1e-07
        },
      "moving_average": {
          "type": "exponential",
          "decay": 0.9999
      },
      "summary_interval": 100,
      "validation_metric": "+acc"
  },

  "random_seed": utils.parse_number(std.extVar("SEED")),
  "numpy_seed": utils.parse_number(std.extVar("SEED")),
  "pytorch_seed": utils.parse_number(std.extVar("SEED"))

}