#!/bin/bash
# These are picked up from the Docker ENV.
AIRFLOW_DIR=${INSTALL_DIR}/${PARCEL_NAME}

PYVER=$(echo "$PYTHON_VERSION" | awk -F. '{print $1"."$2}')

echo "Updating the shebang..."
for FILE in $(file "${AIRFLOW_DIR}"/bin/* | awk -F: '/Python script, .* text executable/ || /a .*\/AIRFLOW-.* script.* text executable/ {print $1}'); do
  sed -e "1s|.*|#!/usr/bin/env python${PYVER}|" -i "$FILE"
done

install -m 0755 -o root -g root /dev/null "${AIRFLOW_DIR}/bin/airflow.sh"
cat <<EOF >"${AIRFLOW_DIR}/bin/airflow.sh"
#!/bin/bash
export PATH=${AIRFLOW_DIR}/bin:\$PATH
export PYTHONHOME=${AIRFLOW_DIR}
export PYTHONPATH=${AIRFLOW_DIR}/lib/python${PYVER}
export AIRFLOW_HOME=/var/lib/airflow
exec ${AIRFLOW_DIR}/bin/airflow \$@
EOF

rm -f "${AIRFLOW_DIR}/LICENSE"

