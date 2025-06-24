#! /bin/sh

DATASET_PATH="/mnt/data4_hdd/peizhi/Datasets/avatar-datasets-processed/IMAvatar_VHAP"


SUBJECT_LIST=("subject1" "subject2" "subject3")

# Loop over all subjects and sequences
for SUBJECT in "${SUBJECT_LIST[@]}"; do
  SUBJECT_PATH="${DATASET_PATH}/${SUBJECT}"

  for SEQUENCE in $(ls -1 "${SUBJECT_PATH}"); do

    INPUT_PATH="${DATASET_PATH}/${SUBJECT}/${SEQUENCE}"*

    # Check if matching path exists
    if compgen -G "$INPUT_PATH" > /dev/null; then
      echo "Processing SUBJECT: $SUBJECT, SEQUENCE: $SEQUENCE"

      # Run preprocessing script
      python vhap/preprocess_video_from_images.py \
      --image_dir ${INPUT_PATH}
    else
      echo "Skipping SUBJECT: $SUBJECT, SEQUENCE: $SEQUENCE (path not found)"
    fi

  done
done




# TRACK_OUTPUT_FOLDER="/mnt/data4_hdd/peizhi/Datasets/nersemble-v2-vhap/${SUBJECT}/${SEQUENCE}"

# python vhap/track_nersemble_v2.py --data.root_folder ${DATASET_PATH} \
# --exp.output_folder $TRACK_OUTPUT_FOLDER \
# --data.subject $SUBJECT --data.sequence $SEQUENCE \
# --data.n_downsample_rgb 4

