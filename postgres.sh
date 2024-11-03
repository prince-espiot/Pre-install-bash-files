#!/bin/bash

# Prompt the user for input
read -p "Enter RDS hostname: " rds_hostname
read -p "Enter RDS root user: " rds_root_user
read -p "Enter new database name: " PGDATABASE
read -p "Enter new database user: " PGUSER
read -sp "Enter password for new database user: " PGPASSWORD
echo ""

# Execute the commands in PostgreSQL
psql -h "$rds_hostname" -U "$rds_root_user" -d postgres <<EOF
CREATE DATABASE $PGDATABASE;
CREATE USER $PGUSER WITH PASSWORD '$PGPASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGUSER;
ALTER DATABASE $PGDATABASE OWNER TO $PGUSER;
EOF

# Check if the commands were successful
if [ $? -eq 0 ]; then
  echo "Database and user creation, privileges assignment, and ownership change were successful."
else
  echo "An error occurred while executing the PostgreSQL commands."
fi
