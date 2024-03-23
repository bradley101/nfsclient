#include <stdio.h>
#include <stdlib.h>
#include "nfs3.h" // Include the generated header file
#include <string.h>

int main(int argc, char *argv[]) {
    CLIENT *cl;
    char *server;
    GETATTR3args args;
    GETATTR3res *res;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <hostname> <file_handle>\n", argv[0]);
        exit(1);
    }

    server = argv[1];
    args.object.data.data_val = (char *)argv[2];
    args.object.data.data_len = strlen(argv[2]);

    cl = clnt_create(server, NFS_PROGRAM, NFS_V3, "udp");
    if (cl == NULL) {
        clnt_pcreateerror(server);
        exit(1);
    }

    res = nfsproc3_getattr_3(&args, cl);

    if (res->status == NFS3_OK) {
        // Handle the successful response here
        printf("Attributes:\n");
        // Access the attributes in res.resok.obj_attributes
    } else {
        // Handle errors here
        printf("RPC Error: %d\n", res->status);
    }

    clnt_destroy(cl);
    return 0;
}
