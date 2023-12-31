// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef NETDATA_SQLITE_ACLK_NODE_H
#define NETDATA_SQLITE_ACLK_NODE_H

void aclk_check_node_info_and_collectors(void);
bool host_finished_replication(RRDHOST *host);
#endif //NETDATA_SQLITE_ACLK_NODE_H
