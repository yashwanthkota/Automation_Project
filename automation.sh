s3_bucket="upgrad-yashwanth"
myname="Yashwanth"

sudo apt update -y
dpkg -s apache2 &> /dev/null

if [ $? -eq 0 ]; then
    echo "Package apache2 is installed!"
else
    echo "Package apache2 is NOT installed!Installing the package..."
    sudo apt-get install apache2
fi
service apache2 status
timestamp=$(date '+%d%m%Y-%H%M%S')

tar cvf "$myname-httpd-logs-$timestamp.tar" /var/log/apache2/*.log
cp $myname-httpd-logs-$timestamp.tar /tmp/

aws s3 \
cp /tmp/$myname-httpd-logs-$timestamp.tar \
s3://$s3_bucket/$myname-httpd-logs-$timestamp.tar
