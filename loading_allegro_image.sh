#!/bin/bash


echo "1. running containers ids: "
running_containers_ids=$(docker ps -q)
if [[ $running_containers_ids ]]
    then
        echo $running_containers_ids
    else
        echo "1.1. there is no running containers!"
fi

if [[ $running_containers_ids ]]
    then
        echo "1.1.1. stop running containers..."
        docker stop $running_containers_ids
fi

echo "2. all containers ids: "
all_containers_ids=$(docker ps -a -q)
if [[ $all_containers_ids ]]
    then
        echo $all_containers_ids
    else
        echo "2.2. there is no containers!"
fi

if [[ $all_containers_ids ]]
    then
        echo "2.2.2. remove all containers..."
        docker rm $all_containers_ids
fi

echo "3. docker images ids: "
images_ids=$(docker images -q)
if [[ $images_ids ]]
    then
        echo $images_ids
    else
        echo "3.3. there is no images!"
fi

if [[ $images_ids ]]
    then
        echo "3.3.3. remove images..."
        docker rmi $images_ids
fi



echo "4. going to Allegro_Downloads..."
cd /root/Documents/Allegro_Downloads
pwd
echo "5. Allegro_Downloads clearing..."
rm *
echo "6. clearing results:"
ls -la

echo "7. loading build..."
address=$1
echo "load image from" $address
wget $address

echo "8. load image from the archive..."
archive=$(find . -name "allegro*")
echo "archive found: " $archive
docker load -i $archive


echo "9. run image..."
image_info=$(docker images | grep -E '^allegro/devopsimage')
image=$(echo $image_info | awk -e '{print $1}')
tag=$(echo $image_info | awk -e '{print $2}')

echo "image info: "
echo $image_info

echo "image:tag" $image:$tag

docker run -d -p 81:80 -p 444:443 -v /root/Documents/allegro_volume:/data $image:$tag

