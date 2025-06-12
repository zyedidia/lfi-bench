// simple_xml_parse.c
#include <stdio.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s filename.xml\n", argv[0]);
        return 1;
    }

    const char *filename = argv[1];

    // Initialize libxml2 library (optional in newer versions)
    LIBXML_TEST_VERSION

    // Parse the XML file into a tree
    xmlDoc *doc = xmlReadFile(filename, NULL, 0);
    if (doc == NULL) {
        fprintf(stderr, "Error: could not parse file %s\n", filename);
        return 1;
    }

    // Get the root element node
    xmlNode *root_element = xmlDocGetRootElement(doc);
    if (root_element == NULL) {
        fprintf(stderr, "Error: empty document\n");
        xmlFreeDoc(doc);
        return 1;
    }

    // Print the name of the root element
    printf("Root element: %s\n", (const char *) root_element->name);

    // Free the document
    xmlFreeDoc(doc);

    // Clean up parser
    xmlCleanupParser();

    return 0;
}
