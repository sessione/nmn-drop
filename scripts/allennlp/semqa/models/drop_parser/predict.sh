#!/usr/bin/env

export TMPDIR=/srv/local/data/nitishg/tmp

### DATASET PATHS -- should be same across models for same dataset
DATASET_NAME=date_prune_augment_50
DATASET_DIR=./resources/data/drop/${DATASET_NAME}
TRAINFILE=${DATASET_DIR}/drop_dataset_train.json
VALFILE=${DATASET_DIR}/drop_dataset_dev.json

# PACKAGE TO BE INCLUDED WHICH HOUSES ALL THE CODE
INCLUDE_PACKAGE=semqa

# Check CONFIGFILE for environment variables to set
export GPU=0

# All parameters here are used to fetch the correct serialization_dir
export TOKENIDX="qanet"

export BS=8
export DROPOUT=0.2
export LR=0.0005

export WEMB_DIM=100
export RG=1e-4

export GOLDACTIONS=false
export GOLDPROGS=false
export DENLOSS=false
export EXCLOSS=false
export QATTLOSS=true
export MMLLOSS=true

# Whether strong supervison instances should be trained on first, if yes for how many epochs
export SUPFIRST=true
export SUPEPOCHS=20

export SEED=100

export BEAMSIZE=2

export DEBUG=true

####    SERIALIZATION DIR --- Check for checkpoint_root/task/dataset/model/parameters/
CHECKPOINT_ROOT=./resources/semqa/checkpoints
SERIALIZATION_DIR_ROOT=${CHECKPOINT_ROOT}/drop/${DATASET_NAME}
MODEL_DIR=drop_parser
PD_1=BS_${BS}/LR_${LR}/Drop_${DROPOUT}/TOKENS_${TOKENIDX}/ED_${WEMB_DIM}/RG_${RG}/GACT_${GOLDACTIONS}/GPROGS_${GOLDPROGS}
PD_2=QAL_${DENLOSS}/EXL_${EXCLOSS}/QATL_${QATTLOSS}/MML_${MMLLOSS}/SUPFIRST_${SUPFIRST}/SUPEPOCHS_${SUPEPOCHS}
SERIALIZATION_DIR=${SERIALIZATION_DIR_ROOT}/${MODEL_DIR}/${PD_1}/${PD_2}/S_${SEED}/test

# PREDICTION DATASET
PREDICT_OUTPUT_DIR=${SERIALIZATION_DIR}/predictions
mkdir ${PREDICT_OUTPUT_DIR}

#*****************    PREDICTION FILENAME   *****************
PRED_FILENAME=dev_predictions.txt
TESTFILE=${VALFILE}
#PRED_FILENAME=train_predictions.txt
#TESTFILE=${TRAINFILE}
MODEL_TAR=${SERIALIZATION_DIR}/model.tar.gz
PREDICTION_FILE=${PREDICT_OUTPUT_DIR}/${PRED_FILENAME}
PREDICTOR=drop_parser_predictor

#######################################################################################################################


allennlp predict --output-file ${PREDICTION_FILE} \
                 --predictor ${PREDICTOR} \
                 --cuda-device ${GPU} \
                 --include-package ${INCLUDE_PACKAGE} \
                 --silent \
                 --batch-size 1 \
                 --use-dataset-reader \
                 --overrides "{"model": {"decoder_beam_search": {"beam_size": ${BEAMSIZE}}, "debug": ${DEBUG}}}" \
                 ${MODEL_TAR} ${TESTFILE}

# --weights-file ${SERIALIZATION_DIR}/model_state_epoch_9.th \

#allennlp evaluate --output-file ${PREDICTION_FILE} \
#                  --cuda-device ${GPU} \
#                  --include-package ${INCLUDE_PACKAGE} \
#                  ${MODEL_TAR} ${TESTFILE}



echo -e "Predictions file saved at: ${PREDICTION_FILE}"