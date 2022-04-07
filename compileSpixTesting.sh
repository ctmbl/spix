HOME='/home/clemab'
PATH='/home/clemab/.local/bin:/home/clemab/bin:/usr/share/Modules/bin:/usr/lib64/ccache:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin'
IFS=' '
source $HOME/.bashrc

cd $HOME/Documents/spix/examples/SpixTestingV1
#ninja -C build SpixTestingV1

cmake -DSPIX_QT_MAJOR=5 -DQt5_ROOT=/home/clemab/Documents/Qt/gcc_64 -DAnyRPC_ROOT=$HOME/Documents/dependencies -DSpix_ROOT=$HOME/Documents/dependencies -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -GNinja -Bbuild 

cmake --build build
