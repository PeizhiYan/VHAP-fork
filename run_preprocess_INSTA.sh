#! /bin/sh

DATASET_PATH="/mnt/data4_hdd/peizhi/Datasets/avatar-datasets-processed/INSTA_VHAP"


# Loop over all subjects and sequences
for SUBJECT in $(ls -1 "${DATASET_PATH}"); do
  SUBJECT_PATH="${DATASET_PATH}/${SUBJECT}"

  INPUT_PATH=${SUBJECT_PATH}

  if compgen -G "$INPUT_PATH" > /dev/null; then
    echo "Processing SUBJECT: $SUBJECT"

    # Run preprocessing script
    python vhap/preprocess_video_from_images.py \
    --image_dir ${INPUT_PATH}
  else
    echo "Skipping SUBJECT: $SUBJECT (path not found)"
  fi

done




# TRACK_OUTPUT_FOLDER="/mnt/data4_hdd/peizhi/Datasets/nersemble-v2-vhap/${SUBJECT}/${SEQUENCE}"

# python vhap/track_nersemble_v2.py --data.root_folder ${DATASET_PATH} \
# --exp.output_folder $TRACK_OUTPUT_FOLDER \
# --data.subject $SUBJECT --data.sequence $SEQUENCE \
# --data.n_downsample_rgb 4

