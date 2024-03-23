const PROGRAM = 100003;
const VERSION = 3;

const NFS3_FHSIZE = 64;
const NFS3_COOKIEVERFSIZE = 8;
const NFS3_CREATEVERFSIZE = 8;
const NFS3_WRITEVERFSIZE = 8;

typedef unsigned hyper uint64;
typedef hyper int64;
typedef unsigned long uint32;
typedef long int32;
typedef string filename3<>;
typedef string nfspath3<>;
typedef uint64 fileid3;
typedef uint64 cookie3;
typedef opaque cookieverf3[NFS3_COOKIEVERFSIZE];
typedef opaque createverf3[NFS3_CREATEVERFSIZE];
typedef opaque writeverf3[NFS3_WRITEVERFSIZE];
typedef uint32 uid3;
typedef uint32 gid3;
typedef uint64 size3;
typedef uint64 offset3;
typedef uint32 mode3;
typedef uint32 count3;

enum nfsstat3 {
    NFS3_OK             = 0,
    NFS3ERR_PERM        = 1,
    NFS3ERR_NOENT       = 2,
    NFS3ERR_IO          = 5,
    NFS3ERR_NXIO        = 6,
    NFS3ERR_ACCES       = 13,
    NFS3ERR_EXIST       = 17,
    NFS3ERR_XDEV        = 18,
    NFS3ERR_NODEV       = 19,
    NFS3ERR_NOTDIR      = 20,
    NFS3ERR_ISDIR       = 21,
    NFS3ERR_INVAL       = 22,
    NFS3ERR_FBIG        = 27,
    NFS3ERR_NOSPC       = 28,
    NFS3ERR_ROFS        = 30,
    NFS3ERR_MLINK       = 31,
    NFS3ERR_NAMETOOLONG = 63,
    NFS3ERR_NOTEMPTY    = 66,
    NFS3ERR_DQUOT       = 69,
    NFS3ERR_STALE       = 70,
    NFS3ERR_REMOTE      = 71,
    NFS3ERR_BADHANDLE   = 10001,
    NFS3ERR_NOT_SYNC    = 10002,
    NFS3ERR_BAD_COOKIE  = 10003,
    NFS3ERR_NOTSUPP     = 10004,
    NFS3ERR_TOOSMALL    = 10005,
    NFS3ERR_SERVERFAULT = 10006,
    NFS3ERR_BADTYPE     = 10007,
    NFS3ERR_JUKEBOX     = 10008
};

enum ftype3 {
    NF3REG    = 1,
    NF3DIR    = 2,
    NF3BLK    = 3,
    NF3CHR    = 4,
    NF3LNK    = 5,
    NF3SOCK   = 6,
    NF3FIFO   = 7
};

struct specdata3 {
    uint32     specdata1;
    uint32     specdata2;
};

struct nfs_fh3 {
    opaque       data<NFS3_FHSIZE>;
};

struct nfstime3 {
    uint32   seconds;
    uint32   nseconds;
};

struct fattr3 {
    ftype3     type;
    mode3      mode;
    uint32     nlink;
    uid3       uid;
    gid3       gid;
    size3      size;
    size3      used;
    specdata3  rdev;
    uint64     fsid;
    fileid3    fileid;
    nfstime3   atime;
    nfstime3   mtime;
    nfstime3   ctime;
};

union post_op_attr switch (bool attributes_follow) {
case TRUE:
    fattr3   attributes;
case FALSE:
    void;
};

struct wcc_attr {
    size3       size;
    nfstime3    mtime;
    nfstime3    ctime;
};

union pre_op_attr switch (bool attributes_follow) {
case TRUE:
    wcc_attr  attributes;
case FALSE:
    void;
};

struct wcc_data {
    pre_op_attr    before;
    post_op_attr   after;
};

union post_op_fh3 switch (bool handle_follows) {
case TRUE:
    nfs_fh3  handle;
case FALSE:
    void;
};

enum time_how {
    DONT_CHANGE        = 0,
    SET_TO_SERVER_TIME = 1,
    SET_TO_CLIENT_TIME = 2
};

union set_mode3 switch (bool set_it) {
case TRUE:
    mode3    mode;
default:
    void;
};

union set_uid3 switch (bool set_it) {
case TRUE:
    uid3     uid;
default:
    void;
};

union set_gid3 switch (bool set_it) {
case TRUE:
    gid3     gid;
default:
    void;
};

union set_size3 switch (bool set_it) {
case TRUE:
    size3    size;
default:
    void;
};

union set_atime switch (time_how set_it) {
case SET_TO_CLIENT_TIME:
    nfstime3  atime;
default:
    void;
};

union set_mtime switch (time_how set_it) {
case SET_TO_CLIENT_TIME:
    nfstime3  mtime;
default:
    void;
};

struct sattr3 {
    set_mode3   mode;
    set_uid3    uid;
    set_gid3    gid;
    set_size3   size;
    set_atime   atime;
    set_mtime   mtime;
};

struct diropargs3 {
    nfs_fh3     dir;
    filename3   name;
};

struct GETATTR3args {
    nfs_fh3  object;
};

struct GETATTR3resok {
    fattr3   obj_attributes;
};

union GETATTR3res switch (nfsstat3 status) {
case NFS3_OK:
    GETATTR3resok  resok;
default:
    void;
};

union sattrguard3 switch (bool check) {
case TRUE:
    nfstime3  obj_ctime;
case FALSE:
    void;
};

struct SETATTR3args {
    nfs_fh3      object;
    sattr3       new_attributes;
    sattrguard3  guard;
};

struct SETATTR3resok {
    wcc_data  obj_wcc;
};

struct SETATTR3resfail {
    wcc_data  obj_wcc;
};

union SETATTR3res switch (nfsstat3 status) {
case NFS3_OK:
    SETATTR3resok   resok;
default:
    SETATTR3resfail resfail;
};



program NFS_PROGRAM {
    version NFS_V3 {

        void
            NFSPROC3_NULL(void)                    = 0;

        GETATTR3res
            NFSPROC3_GETATTR(GETATTR3args)         = 1;
/*
        SETATTR3res
            NFSPROC3_SETATTR(SETATTR3args)         = 2;

        LOOKUP3res
            NFSPROC3_LOOKUP(LOOKUP3args)           = 3;

        ACCESS3res
            NFSPROC3_ACCESS(ACCESS3args)           = 4;

        READLINK3res
            NFSPROC3_READLINK(READLINK3args)       = 5;

        READ3res
            NFSPROC3_READ(READ3args)               = 6;

        WRITE3res
            NFSPROC3_WRITE(WRITE3args)             = 7;

        CREATE3res
            NFSPROC3_CREATE(CREATE3args)           = 8;

        MKDIR3res
            NFSPROC3_MKDIR(MKDIR3args)             = 9;

        SYMLINK3res
            NFSPROC3_SYMLINK(SYMLINK3args)         = 10;

        MKNOD3res
            NFSPROC3_MKNOD(MKNOD3args)             = 11;

        REMOVE3res
            NFSPROC3_REMOVE(REMOVE3args)           = 12;

        RMDIR3res
            NFSPROC3_RMDIR(RMDIR3args)             = 13;

        RENAME3res
            NFSPROC3_RENAME(RENAME3args)           = 14;

        LINK3res
            NFSPROC3_LINK(LINK3args)               = 15;

        READDIR3res
            NFSPROC3_READDIR(READDIR3args)         = 16;

        READDIRPLUS3res
            NFSPROC3_READDIRPLUS(READDIRPLUS3args) = 17;

        FSSTAT3res
            NFSPROC3_FSSTAT(FSSTAT3args)           = 18;

        FSINFO3res
            NFSPROC3_FSINFO(FSINFO3args)           = 19;

        PATHCONF3res
            NFSPROC3_PATHCONF(PATHCONF3args)       = 20;

        COMMIT3res
            NFSPROC3_COMMIT(COMMIT3args)           = 21;
*/
    } = 3;
} = 100003;

