#!/bin/bash

BACKUP_DIR=${HOME}/backup
FILE_MAX_NUM=2

cd $BACKUP_DIR

rename_file()
{
    i=$FILE_MAX_NUM
    while [ $i -gt 0 ];
    do
        older_name="$1.$i.$2"
        newer_name="$1.$((i - 1)).$2"
        if [ -f $newer_name ]; then
           mv $newer_name $older_name 
        fi
        i=$((i - 1));
    done
}


#backup mysql database -- chinese blog
rename_file "wpdb.sql" "gz"
mysqldump -u$DB_USER_NAME -p$DB_PASSWORD wordpress | gzip > wpdb.sql.0.gz
chmod 600 wpdb.sql.0.gz

#backup mysql database -- english blog
rename_file "wpdb_en.sql" "gz"
mysqldump -u$DB_USER_NAME -p$DB_PASSWORD wordpress_en | gzip > wpdb_en.sql.0.gz
chmod 600 wpdb_en.sql.0.gz

#backup /var/www dir
rename_file 'site' 'tgz'
tar czvf 'site.0.tgz' '/var/www'
chmod 600 site.0.tgz
