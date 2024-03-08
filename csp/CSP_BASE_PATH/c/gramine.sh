if [ -f "Makefile" ]; then
    rm Makefile
fi
touch Makefile
cat makefile.template >> Makefile
make clean
make
gramine-sgx c
echo -e "\n### Enclave terminates its execution ###\n"