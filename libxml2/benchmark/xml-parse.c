#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <xml_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("open");
        return EXIT_FAILURE;
    }

    struct stat st;
    if (fstat(fd, &st) < 0) {
        perror("fstat");
        close(fd);
        return EXIT_FAILURE;
    }

    size_t filesize = st.st_size;
    if (filesize == 0) {
        fprintf(stderr, "Error: File is empty\n");
        close(fd);
        return EXIT_FAILURE;
    }

    void *data = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, fd, 0);
    if (data == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return EXIT_FAILURE;
    }

    // Initialize libxml2
    xmlInitParser();

    // Parse the XML from the memory-mapped file
    xmlDocPtr doc = xmlReadMemory((const char *)data, filesize, filename, NULL, 0);
    if (doc == NULL) {
        fprintf(stderr, "Failed to parse XML file.\n");
        munmap(data, filesize);
        close(fd);
        return EXIT_FAILURE;
    }

    // Get and print the root element
    xmlNode *root = xmlDocGetRootElement(doc);
    if (root) {
        printf("Root element: %s\n", (const char *)root->name);
    } else {
        printf("Empty document or no root element.\n");
    }

    return EXIT_SUCCESS;
}

