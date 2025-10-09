#include <microhttpd.h>
#include <string.h>
#include <stdio.h>

#define PORT 8080

static enum MHD_Result answer_to_connection(void *cls, struct MHD_Connection *connection,
                                           const char *url, const char *method,
                                           const char *version, const char *upload_data,
                                           size_t *upload_data_size, void **con_cls) {
    const char *page = "{\"message\":\"Hello, world!\"}";
    struct MHD_Response *response;
    enum MHD_Result ret;

    if (strcmp(url, "/hello") != 0)
        return MHD_NO;

    response = MHD_create_response_from_buffer(strlen(page), (void *)page, MHD_RESPMEM_PERSISTENT);
    MHD_add_response_header(response, "Content-Type", "application/json");
    ret = MHD_queue_response(connection, MHD_HTTP_OK, response);
    MHD_destroy_response(response);

    return ret;
}

int main() {
    struct MHD_Daemon *daemon;

    daemon = MHD_start_daemon(MHD_USE_SELECT_INTERNALLY, PORT, NULL, NULL,
                             &answer_to_connection, NULL, MHD_OPTION_END);
    if (NULL == daemon)
        return 1;

    printf("Server running on port %d\n", PORT);
    pause();

    MHD_stop_daemon(daemon);
    return 0;
}
