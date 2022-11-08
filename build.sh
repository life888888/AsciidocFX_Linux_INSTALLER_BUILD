export ASCIIDOCFX_VERSION=1.8.2
export APP_DIR=`pwd`
export BUILD_DIR=${APP_DIR}/build
export CACHE_DIR=${APP_DIR}/local-cache
export RELEASES_DIR=${APP_DIR}/releases
export SRC_FILE=AsciidocFX_Linux.tar.gz

echo "APP_DIR=${APP_DIR}"
echo "BUILD_DIR=${BUILD_DIR}"
echo "CACHE_DIR=${CACHE_DIR}"
echo "RELEASES_DIR=${RELEASES_DIR}"

mkdir -p ${BUILD_DIR}
mkdir -p ${CACHE_DIR}
mkdir -p ${RELEASES_DIR}

cd ${CACHE_DIR}
if [ ! -f "${SRC_FILE}" ]; then
   echo "${SRC_FILE} not found!"
   wget https://github.com/asciidocfx/AsciidocFX/releases/download/v${ASCIIDOCFX_VERSION}/AsciidocFX_Linux.tar.gz
else
   echo "${SRC_FILE} is existing!"
fi

if [ ! -f "duke.png" ]; then
   echo "duke.png not found!"
   wget https://github.com/asciidocfx/Asciidoc-Book-Demo/raw/master/images/duke.png
else
   echo "duke.png is existing!"
fi


cd ${BUILD_DIR}

rm -r * 2> /dev/null || true

cat << 'EOF' > asciidocfx.mime.properties
mime-type=text/asciidoc
extension=adoc
description=Asciidoc
EOF

cp ${CACHE_DIR}/${SRC_FILE} ${BUILD_DIR}/
tar -xvzf AsciidocFX_Linux.tar.gz

cp ${CACHE_DIR}/duke.png AsciidocFX/splash.png

cd AsciidocFX
mv jre ../
rm AsciidocFX
rm AsciidocFX.vmoptions
# KEEP .install4j
# GUESS EXISTING SOME HARD CODE FOR .install4j
# IF REMOVE .install4j WILL POPUP SOME ERROR MESSAGES!

cd ..

echo "START PACKAGING..."

jpackage \
--name AsciidocFX \
--app-version ${ASCIIDOCFX_VERSION} \
--input AsciidocFX \
--main-jar lib/AsciidocFX-${ASCIIDOCFX_VERSION}.jar \
--runtime-image jre \
--java-options -Xms128M \
--java-options -Xmx756M \
--java-options -Duser.language=en \
--java-options -Duser.country=US \
--java-options -Dfile.encoding=UTF-8 \
--java-options -Djava.awt.headless=false \
--java-options -Dsun.java2d.metal=true \
--java-options -Dorg.apache.xml.dtm.DTMManager=org.apache.xml.dtm.ref.DTMManagerDefault \
--java-options "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
--java-options "--add-opens java.base/java.io=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.scene.layout=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.util=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.application=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.sg.prism=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.logging=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.prism=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.glass.ui=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.geom.transform=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.glass.utils=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.font=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.scene.text=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.reflect=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.beans=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.collections=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.scene.traversal=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.stage=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.binding=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.geom=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.iio=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.prism.paint=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.scenario.effect=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.text=ALL-UNNAMED" \
--java-options "--add-opens javafx.base/com.sun.javafx.collections=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.scenario.effect.impl.prism=ALL-UNNAMED" \
--java-options "--add-exports javafx.graphics/com.sun.javafx.css=ALL-UNNAMED" \
--java-options "--add-opens javafx.base/com.sun.javafx.collections=javafx.web" \
--java-options "--add-opens javafx.controls/javafx.scene.control=ALL-UNNAMED" \
--java-options "--add-exports javafx.base/com.sun.javafx.property=ALL-UNNAMED" \
--java-options "--add-exports javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED" \
--java-options "--add-modules=ALL-MODULE-PATH" \
--java-options "--add-modules=javafx.controls,javafx.fxml,javafx.graphics,javafx.media,javafx.swing,javafx.web" \
--java-options "-splash:\$APPDIR/splash.png" \
--main-class com.kodedu.boot.AppStarter \
--icon AsciidocFX/conf/public/logo.png \
--linux-shortcut \
--about-url https://asciidocfx.com/ \
--file-associations asciidocfx.mime.properties

# CHECK IF RPM # $? ==0 RPM
which rpm

if [ $? -eq 0 ]
then
   # asciidocfx-1.8.2-1.x86_64.rpm
   mv ${BUILD_DIR}/asciidocfx*.rpm ${RELEASES_DIR}/
fi

# CHECK IF DEB # $? ==0 DEB
which dpkg

if [ $? -eq 0 ]
then
   # asciidocfx_1.8.2_amd64.deb
   mv ${BUILD_DIR}/asciidocfx*.deb ${RELEASES_DIR}/
fi

cd ${RELEASES_DIR}/
export FILE_LIST=`ls`
echo "PACKAGE RESULT IS IN THE ${RELEASES_DIR}/${FILE_LIST}"

cd ${APP_DIR}/
echo "DONE!"
