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
file="/tmp/$myname-httpd-logs-$timestamp.tar"
test -f /var/www/html/inventory.html || echo -e "Log Type\tTime Created\tType\tSize" > /var/www/html/inventory.html
echo -e  "httpd-logs\t$timestamp\ttar\t$(sudo du $file | awk '{print $1,"K"}')" >> /var/www/html/inventory.html

if  grep "automation.sh" /etc/cron.d/automation
then
        echo "Cron job exists"
else
        echo "15 15 * * * root /home/ubuntu/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
