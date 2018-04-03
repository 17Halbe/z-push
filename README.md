## Z-Push Image for tvial/docker-mailserver

This z-push image is designed to work in lieu with the tvial/docker-mailserver (see [tomav/docker-mailserver](https://github.com/tomav/docker-mailserver) for further information.)

#### The following variables are currently used:

- `TIMEZONE`: in the format of `Europe/Zurich`
- `IMAP_SERVER`: your imap server address/ip
- `IMAP_PORT`: imap port
- `SMTP_SERVER`: smtp server address/ip
- `SMTP_PORT`: smtp port

## Device Setup

For a quick guide, how to setup up your mobile device, have a look at the [Zarafa-Homepage](https://doc.zarafa.com/7.1/User_Manual/en-US/html/_configure_mobile_platforms.html)

## Configuration

If you need to change the default configuration, you can do so by placing a `config.php` and/or a `imap.php` into a folder which has to be mounted as a volume to `/config/` inside the container.

**Note:** Those files just get appended to the container configuration files for now.

Example:

```
  docker run -d -name z-push \
  -v ./config:/config/ \
  -e TIMEZONE=Europe/Zurich \
  -e IMAP_SERVER=imap.yourdomain.tld \
  -e IMAP_PORT=143 \
  -e SMTP_SERVER=smtp.yourdomain.tld \
  -e SMTP_PORT=465 \
  17halbe/z-push`
```
The used configuration is being put out to the docker logs upon container start, and can be read by `docker logs <your_container_name>`

Here are the settings used at the time of writing:

### config.php
```php
<?php
/***********************************************
* File      :   config.php
* Project   :   Z-Push
* Descr     :   Main configuration file
*
* Created   :   01.10.2007
*
* Copyright 2007 - 2016 Zarafa Deutschland GmbH
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License, version 3,
* as published by the Free Software Foundation.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* Consult LICENSE file for details
************************************************/

/**********************************************************************************
 *  Default settings
 */
    // Defines the default time zone, change e.g. to "Europe/London" if necessary
    define('TIMEZONE', '');

    // Defines the base path on the server
    define('BASE_PATH', dirname($_SERVER['SCRIPT_FILENAME']). '/');

    // Try to set unlimited timeout
    define('SCRIPT_TIMEOUT', 0);

    // When accessing through a proxy, the "X-Forwarded-For" header contains the original remote IP
    define('USE_X_FORWARDED_FOR_HEADER', false);

    // When using client certificates, we can check if the login sent matches the owner of the certificate.
    // This setting specifies the owner parameter in the certificate to look at.
    define("CERTIFICATE_OWNER_PARAMETER", "SSL_CLIENT_S_DN_CN");

    /*
     * Whether to use the complete email address as a login name
     * (e.g. user@company.com) or the username only (user).
     * This is required for Z-Push to work properly after autodiscover.
     * Possible values:
     *   false - use the username only.
     *   true  - string the mobile sends as username, e.g. full email address (default).
     */
    define('USE_FULLEMAIL_FOR_LOGIN', true);

/**********************************************************************************
 * StateMachine setting
 *
 * These StateMachines can be used:
 *   FILE  - FileStateMachine (default). Needs STATE_DIR set as well.
 *   SQL   - SqlStateMachine has own configuration file. STATE_DIR is ignored.
 *           State migration script is available, more informations: https://wiki.z-hub.io/x/xIAa
 */
    define('STATE_MACHINE', 'FILE');
    define('STATE_DIR', '/state/');

/**********************************************************************************
 *  IPC - InterProcessCommunication
 *
 *  Is either provided by using shared memory on a single host or
 *  using the memcache provider for multi-host environments.
 *  When another implementation should be used, the class can be set here explicitly.
 *  If empty Z-Push will try to use available providers.
 */
    define('IPC_PROVIDER', '');

/**********************************************************************************
 *  Logging settings
 *
 *  The LOGBACKEND specifies where the logs are sent to.
 *  Either to file ("filelog") or to a "syslog" server or a custom log class in core/log/logclass.
 *  filelog and syslog have several options that can be set below.
 *  For more information about the syslog configuration, see https://wiki.z-hub.io/x/HIAT

 *  Possible LOGLEVEL and LOGUSERLEVEL values are:
 *  LOGLEVEL_OFF            - no logging
 *  LOGLEVEL_FATAL          - log only critical errors
 *  LOGLEVEL_ERROR          - logs events which might require corrective actions
 *  LOGLEVEL_WARN           - might lead to an error or require corrective actions in the future
 *  LOGLEVEL_INFO           - usually completed actions
 *  LOGLEVEL_DEBUG          - debugging information, typically only meaningful to developers
 *  LOGLEVEL_WBXML          - also prints the WBXML sent to/from the device
 *  LOGLEVEL_DEVICEID       - also prints the device id for every log entry
 *  LOGLEVEL_WBXMLSTACK     - also prints the contents of WBXML stack
 *
 *  The verbosity increases from top to bottom. More verbose levels include less verbose
 *  ones, e.g. setting to LOGLEVEL_DEBUG will also output LOGLEVEL_FATAL, LOGLEVEL_ERROR,
 *  LOGLEVEL_WARN and LOGLEVEL_INFO level entries.
 *
 *  LOGAUTHFAIL is logged to the LOGBACKEND.
 */
    define('LOGBACKEND', 'filelog');
    define('LOGLEVEL', LOGLEVEL_INFO);
    define('LOGAUTHFAIL', false);

    // To save e.g. WBXML data only for selected users, add the usernames to the array
    // The data will be saved into a dedicated file per user in the LOGFILEDIR
    // Users have to be encapusulated in quotes, several users are comma separated, like:
    //   $specialLogUsers = array('info@domain.com', 'myusername');
    define('LOGUSERLEVEL', LOGLEVEL_DEVICEID);
    $specialLogUsers = array();

    // Filelog settings
    define('LOGFILEDIR', '/var/log/z-push/');
    define('LOGFILE', LOGFILEDIR . 'z-push.log');
    define('LOGERRORFILE', LOGFILEDIR . 'z-push-error.log');

    // Syslog settings
    // false will log to local syslog, otherwise put the remote syslog IP here
    define('LOG_SYSLOG_HOST', false);
    // Syslog port
    define('LOG_SYSLOG_PORT', 514);
    // Program showed in the syslog. Useful if you have more than one instance login to the same syslog
    define('LOG_SYSLOG_PROGRAM', 'z-push');
    // Syslog facility - use LOG_USER when running on Windows
    define('LOG_SYSLOG_FACILITY', LOG_LOCAL0);

    // Location of the trusted CA, e.g. '/etc/ssl/certs/EmailCA.pem'
    // Uncomment and modify the following line if the validation of the certificates fails.
    // define('CAINFO', '/etc/ssl/certs/EmailCA.pem');

/**********************************************************************************
 *  Mobile settings
 */
    // Device Provisioning
    define('PROVISIONING', true);

    // This option allows the 'loose enforcement' of the provisioning policies for older
    // devices which don't support provisioning (like WM 5 and HTC Android Mail) - dw2412 contribution
    // false (default) - Enforce provisioning for all devices
    // true - allow older devices, but enforce policies on devices which support it
    define('LOOSE_PROVISIONING', false);

    // The file containing the policies' settings.
    // Set a full path or relative to the z-push main directory
    define('PROVISIONING_POLICYFILE', 'policies.ini');

    // Default conflict preference
    // Some devices allow to set if the server or PIM (mobile)
    // should win in case of a synchronization conflict
    //   SYNC_CONFLICT_OVERWRITE_SERVER - Server is overwritten, PIM wins
    //   SYNC_CONFLICT_OVERWRITE_PIM    - PIM is overwritten, Server wins (default)
    define('SYNC_CONFLICT_DEFAULT', SYNC_CONFLICT_OVERWRITE_PIM);

    // Global limitation of items to be synchronized
    // The mobile can define a sync back period for calendar and email items
    // For large stores with many items the time period could be limited to a max value
    // If the mobile transmits a wider time period, the defined max value is used
    // Applicable values:
    //   SYNC_FILTERTYPE_ALL (default, no limitation)
    //   SYNC_FILTERTYPE_1DAY, SYNC_FILTERTYPE_3DAYS, SYNC_FILTERTYPE_1WEEK, SYNC_FILTERTYPE_2WEEKS,
    //   SYNC_FILTERTYPE_1MONTH, SYNC_FILTERTYPE_3MONTHS, SYNC_FILTERTYPE_6MONTHS
    define('SYNC_FILTERTIME_MAX', SYNC_FILTERTYPE_ALL);

    // Interval in seconds before checking if there are changes on the server when in Ping.
    // It means the highest time span before a change is pushed to a mobile. Set it to
    // a higher value if you have a high load on the server.
    define('PING_INTERVAL', 30);

    // Set the fileas (save as) order for contacts in the webaccess/webapp/outlook.
    // It will only affect new/modified contacts on the mobile which then are synced to the server.
    // Possible values are:
    // SYNC_FILEAS_FIRSTLAST    - fileas will be "Firstname Middlename Lastname"
    // SYNC_FILEAS_LASTFIRST    - fileas will be "Lastname, Firstname Middlename"
    // SYNC_FILEAS_COMPANYONLY  - fileas will be "Company"
    // SYNC_FILEAS_COMPANYLAST  - fileas will be "Company (Lastname, Firstname Middlename)"
    // SYNC_FILEAS_COMPANYFIRST - fileas will be "Company (Firstname Middlename Lastname)"
    // SYNC_FILEAS_LASTCOMPANY  - fileas will be "Lastname, Firstname Middlename (Company)"
    // SYNC_FILEAS_FIRSTCOMPANY - fileas will be "Firstname Middlename Lastname (Company)"
    // The company-fileas will only be set if a contact has a company set. If one of
    // company-fileas is selected and a contact doesn't have a company set, it will default
    // to SYNC_FILEAS_FIRSTLAST or SYNC_FILEAS_LASTFIRST (depending on if last or first
    // option is selected for company).
    // If SYNC_FILEAS_COMPANYONLY is selected and company of the contact is not set
    // SYNC_FILEAS_LASTFIRST will be used
    define('FILEAS_ORDER', SYNC_FILEAS_LASTFIRST);

    // Maximum amount of items to be synchronized per request.
    // Normally this value is requested by the mobile. Common values are 5, 25, 50 or 100.
    // Exporting too much items can cause mobile timeout on busy systems.
    // Z-Push will use the lowest provided value, either set here or by the mobile.
    // MS Outlook 2013+ request up to 512 items to accelerate the sync process.
    // If you detect high load (also on subsystems) you could try a lower setting.
    // max: 512 - value used if mobile does not limit amount of items
    define('SYNC_MAX_ITEMS', 512);

    // The devices usually send a list of supported properties for calendar and contact
    // items. If a device does not includes such a supported property in Sync request,
    // it means the property's value will be deleted on the server.
    // However some devices do not send a list of supported properties. It is then impossible
    // to tell if a property was deleted or it was not set at all if it does not appear in Sync.
    // This parameter defines Z-Push behaviour during Sync if a device does not issue a list with
    // supported properties.
    // See also https://jira.z-hub.io/browse/ZP-302.
    // Possible values:
    // false - do not unset properties which are not sent during Sync (default)
    // true  - unset properties which are not sent during Sync
    define('UNSET_UNDEFINED_PROPERTIES', false);

    // ActiveSync specifies that a contact photo may not exceed 48 KB. This value is checked
    // in the semantic sanity checks and contacts with larger photos are not synchronized.
    // This limitation is not being followed by the ActiveSync clients which set much bigger
    // contact photos. You can override the default value of the max photo size.
    // default: 5242880 - 5 MB default max photo size in bytes
    define('SYNC_CONTACTS_MAXPICTURESIZE', 5242880);

    // Over the WebserviceUsers command it is possible to retrieve a list of all
    // known devices and users on this Z-Push system. The authenticated user needs to have
    // admin rights and a public folder must exist.
    // In multicompany environments this enable an admin user of any company to retrieve
    // this full list, so this feature is disabled by default. Enable with care.
    define('ALLOW_WEBSERVICE_USERS_ACCESS', false);

    // Users with many folders can use the 'partial foldersync' feature, where the server
    // actively stops processing the folder list if it takes too long. Other requests are
    // then redirected to the FolderSync to synchronize the remaining items.
    // Device compatibility for this procedure is not fully understood.
    // NOTE: THIS IS AN EXPERIMENTAL FEATURE WHICH COULD PREVENT YOUR MOBILES FROM SYNCHRONIZING.
    define('USE_PARTIAL_FOLDERSYNC', false);

    // The minimum accepted time in second that a ping command should last.
    // It is strongly advised to keep this config to false. Some device
    // might not be able to send a higher value than the one specificied here and thus
    // unable to start a push connection.
    // If set to false, there will be no lower bound to the ping lifetime.
    // The minimum accepted value is 1 second. The maximum accepted value is 3540 seconds (59 minutes).
    define('PING_LOWER_BOUND_LIFETIME', false);

    // The maximum accepted time in second that a ping command should last.
    // If set to false, there will be no higher bound to the ping lifetime.
    // The minimum accepted value is 1 second. The maximum accepted value is 3540 seconds (59 minutes).
    define('PING_HIGHER_BOUND_LIFETIME', false);

    // Maximum response time
    // Mobiles implement different timeouts to their TCP/IP connections. Android devices for example
    // have a hard timeout of 30 seconds. If the server is not able to answer a request within this timeframe,
    // the answer will not be recieved and the device will send a new one overloading the server.
    // There are three categories
    //   - Short timeout  - server has up within 30 seconds - is automatically applied for not categorized types
    //   - Medium timeout - server has up to 90 seconds to respond
    //   - Long timeout   - server has up to 4 minutes to respond
    // If a timeout is almost reached the server will break and sent the results it has until this
    // point. You can add DeviceType strings to the categories.
    // In general longer timeouts are better, because more data can be streamed at once.
    define('SYNC_TIMEOUT_MEDIUM_DEVICETYPES', "SAMSUNGGTI");
    define('SYNC_TIMEOUT_LONG_DEVICETYPES',   "iPod, iPad, iPhone, WP, WindowsOutlook");

    // Time in seconds the device should wait whenever the service is unavailable,
    // e.g. when a backend service is unavailable.
    // Z-Push sends a "Retry-After" header in the response with the here defined value.
    // It is up to the device to respect or not this directive so even if this option is set,
    // the device might not wait requested time frame.
    // Number of seconds before retry, to disable set to: false
    define('RETRY_AFTER_DELAY', 300);

/**********************************************************************************
 *  Backend settings
 */
    // the backend data provider
    define('BACKEND_PROVIDER', 'BackendIMAP');

/**********************************************************************************
 *  Search provider settings
 *
 *  Alternative backend to perform SEARCH requests (GAL search)
 *  By default the main Backend defines the preferred search functionality.
 *  If set, the Search Provider will always be preferred.
 *  Use 'BackendSearchLDAP' to search in a LDAP directory (see backend/searchldap/config.php)
 */
    define('SEARCH_PROVIDER', '');
    // Time in seconds for the server search. Setting it too high might result in timeout.
    // Setting it too low might not return all results. Default is 10.
    define('SEARCH_WAIT', 10);
    // The maximum number of results to send to the client. Setting it too high
    // might result in timeout. Default is 10.
    define('SEARCH_MAXRESULTS', 10);

/**********************************************************************************
 *  Kopano Outlook Extension - Settings
 *
 *  The Kopano Outlook Extension (KOE) provides MS Outlook 2013 and newer with
 *  functionality not provided by ActiveSync or not implemented by Outlook.
 *  For more information, see: https://wiki.z-hub.io/x/z4Aa
 */
    // Global Address Book functionality
    define('KOE_CAPABILITY_GAB', true);
    // Synchronize mail flags from the server to Outlook/KOE
    define('KOE_CAPABILITY_RECEIVEFLAGS', true);
    // Encode flags when sending from Outlook/KOE
    define('KOE_CAPABILITY_SENDFLAGS', true);
    // Out-of-office support
    define('KOE_CAPABILITY_OOF', true);
    // Out-of-office support with start & end times (superseeds KOE_CAPABILITY_OOF)
    define('KOE_CAPABILITY_OOFTIMES', true);
    // Notes support
    define('KOE_CAPABILITY_NOTES', true);
    // Shared folder support
    define('KOE_CAPABILITY_SHAREDFOLDER', true);
    // Send-As support for Outlook/KOE and mobiles
    define('KOE_CAPABILITY_SENDAS', true);
    // Secondary Contact folders (own and shared)
    define('KOE_CAPABILITY_SECONDARYCONTACTS', true);
    // Copy WebApp signature into KOE
    define('KOE_CAPABILITY_SIGNATURES', true);
    // Delivery receipt requests
    define('KOE_CAPABILITY_RECEIPTS', true);

    // To synchronize the GAB KOE, the GAB store and folderid need to be specified.
    // Use the gab-sync script to generate this data. The name needs to
    // match the config of the gab-sync script.
    // More information here: https://wiki.z-hub.io/x/z4Aa (GAB Sync Script)
    define('KOE_GAB_STORE', 'SYSTEM');
    define('KOE_GAB_FOLDERID', '');
    define('KOE_GAB_NAME', 'Z-Push-KOE-GAB');

/**********************************************************************************
 *  Synchronize additional folders to all mobiles
 *
 *  With this feature, special folders can be synchronized to all mobiles.
 *  This is useful for e.g. global company contacts.
 *
 *  This feature is supported only by certain devices, like iPhones.
 *  Check the compatibility list for supported devices:
 *      http://z-push.org/compatibility
 *
 *  To synchronize a folder, add a section setting all parameters as below:
 *      store:      the ressource where the folder is located.
 *                  Kopano users use 'SYSTEM' for the 'Public Folder'
 *      folderid:   folder id of the folder to be synchronized
 *      name:       name to be displayed on the mobile device
 *      type:       supported types are:
 *                      SYNC_FOLDER_TYPE_USER_CONTACT
 *                      SYNC_FOLDER_TYPE_USER_APPOINTMENT
 *                      SYNC_FOLDER_TYPE_USER_TASK
 *                      SYNC_FOLDER_TYPE_USER_MAIL
 *                      SYNC_FOLDER_TYPE_USER_NOTE
 *
 *  Additional notes:
 *  - on Kopano systems use backend/kopano/listfolders.php script to get a list
 *    of available folders
 *
 *  - all Z-Push users must have at least reading permissions so the configured
 *    folders can be synchronized to the mobile. Else they are ignored.
 *
 *  - this feature is only partly suitable for multi-tenancy environments,
 *    as ALL users from ALL tenents need access to the configured store & folder.
 *    When configuring a public folder, this will cause problems, as each user has
 *    a different public folder in his tenant, so the folder are not available.

 *  - changing this configuration could cause HIGH LOAD on the system, as all
 *    connected devices will be updated and load the data contained in the
 *    added/modified folders.
 */

    $additionalFolders = array(
        // demo entry for the synchronization of contacts from the public folder.
        // uncomment (remove '/*' '*/') and fill in the folderid
/*
        array(
            'store'     => "SYSTEM",
            'folderid'  => "",
            'name'      => "Public Contacts",
            'type'      => SYNC_FOLDER_TYPE_USER_CONTACT,
        ),
*/
    );
```

### imap.php
```php
<?php
/***********************************************
* File      :   config.php
* Project   :   Z-Push
* Descr     :   IMAP backend configuration file
*
* Created   :   27.11.2012
*
* Copyright 2007 - 2016 Zarafa Deutschland GmbH
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License, version 3,
* as published by the Free Software Foundation.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* Consult LICENSE file for details
************************************************/

// ************************
//  BackendIMAP settings
// ************************

// Defines the server to which we want to connect
define('IMAP_SERVER', 'localhost');

// connecting to default port (143)
define('IMAP_PORT', '143');

// best cross-platform compatibility (see http://php.net/imap_open for options)
define('IMAP_OPTIONS', '/tls/norsh/novalidate-cert');


// Mark messages as read when moving to Trash.
//      BE AWARE that you will lose the unread flag, but some mail clients do this so the Trash folder doesn't get boldened
define('IMAP_AUTOSEEN_ON_DELETE', false);


// IMPORTANT: BASIC IMAP FOLDERS [ask your mail admin]
        // We can have diferent cases (case insensitive):
        // 1.
        //      inbox
        //      sent
        //      drafts
        //      trash
        // 2.
        //      inbox
        //      common.sent
        //      common.drafts
        //      common.trash
        // 3.
        //      common.inbox
        //      common.sent
        //      common.drafts
        //      common.trash
        // 4.
        //      common
        //      common.sent
        //      common.drafts
        //      common.trash
        //
        // gmail is a special case, where the default folders are under the [gmail] prefix and the folders defined by the user are under INBOX.
        // This configuration seems to work:
        //      define('IMAP_FOLDER_PREFIX', '');
        //      define('IMAP_FOLDER_PREFIX_IN_INBOX', false);
        //      define('IMAP_FOLDER_INBOX', 'INBOX');
        //      define('IMAP_FOLDER_SENT', '[Gmail]/Sent');
        //      define('IMAP_FOLDER_DRAFT', '[Gmail]/Drafts');
        //      define('IMAP_FOLDER_TRASH', '[Gmail]/Trash');
        //      define('IMAP_FOLDER_SPAM', '[Gmail]/Spam');
        //      define('IMAP_FOLDER_ARCHIVE', '[Gmail]/All Mail');

// Since I know you won't configure this, I will raise an error unless you do.
// When configured set this to true to remove the error
define('IMAP_FOLDER_CONFIGURED', true);

// Folder prefix is the common part in your names (3, 4)
define('IMAP_FOLDER_PREFIX', '');

// Inbox will have the preffix preppend (3 & 4 to true)
define('IMAP_FOLDER_PREFIX_IN_INBOX', false);

// Inbox folder name (case doesn't matter) - (empty in 4)
define('IMAP_FOLDER_INBOX', 'INBOX');

// Sent folder name (case doesn't matter)
define('IMAP_FOLDER_SENT', 'SENT');

// Draft folder name (case doesn't matter)
define('IMAP_FOLDER_DRAFT', 'DRAFTS');

// Trash folder name (case doesn't matter)
define('IMAP_FOLDER_TRASH', 'TRASH');

// Spam folder name (case doesn't matter). Only showed as special by iOS devices
define('IMAP_FOLDER_SPAM', 'SPAM');

// Archive folder name (case doesn't matter). Only showed as special by iOS devices
define('IMAP_FOLDER_ARCHIVE', 'ARCHIVE');



// forward messages inline (default true - inlined)
define('IMAP_INLINE_FORWARD', true);

// list of folders we want to exclude from sync. Names, or part of it, separated by |
// example: dovecot.sieve|archive|spam
define('IMAP_EXCLUDED_FOLDERS', '');



// overwrite the "from" header with some value
// options:
//        ''              - do nothing, use the From header
//        'username'      - the username will be set (usefull if your login is equal to your emailaddress)
//        'domain'        - the value of the "domain" field is used
//        'sql'           - the username will be the result of a sql query. REMEMBER TO INSTALL PHP-PDO AND PHP-DATABASE
//        'ldap'          - the username will be the result of a ldap query. REMEMBER TO INSTALL PHP-LDAP!!
//        '@mydomain.com' - the username is used and the given string will be appended
define('IMAP_DEFAULTFROM', '');

// DSN: formatted PDO connection string
//    mysql:host=xxx;port=xxx;dbname=xxx
// USER: username to DB
// PASSWORD: password to DB
// OPTIONS: array with options needed
// QUERY: query to execute
// FIELDS: columns in the query
// FROM: string that will be the from, replacing the column names with the values
define('IMAP_FROM_SQL_DSN', '');
define('IMAP_FROM_SQL_USER', '');
define('IMAP_FROM_SQL_PASSWORD', '');
define('IMAP_FROM_SQL_OPTIONS', serialize(array(PDO::ATTR_PERSISTENT => true)));
define('IMAP_FROM_SQL_QUERY', "select first_name, last_name, mail_address from users where mail_address = '#username@#domain'");
define('IMAP_FROM_SQL_FIELDS', serialize(array('first_name', 'last_name', 'mail_address')));
define('IMAP_FROM_SQL_FROM', '#first_name #last_name <#mail_address>');
define('IMAP_FROM_SQL_FULLNAME', '#first_name #last_name');

// SERVER: ldap server
// SERVER_PORT: ldap port
// USER: dn to use for connecting
// PASSWORD: password
// QUERY: query to execute
// FIELDS: columns in the query
// FROM: string that will be the from, replacing the field names with the values
define('IMAP_FROM_LDAP_SERVER', 'localhost');
define('IMAP_FROM_LDAP_SERVER_PORT', '389');
define('IMAP_FROM_LDAP_USER', 'cn=zpush,ou=servers,dc=zpush,dc=org');
define('IMAP_FROM_LDAP_PASSWORD', 'password');
define('IMAP_FROM_LDAP_BASE', 'dc=zpush,dc=org');
define('IMAP_FROM_LDAP_QUERY', '(mail=#username@#domain)');
define('IMAP_FROM_LDAP_FIELDS', serialize(array('givenname', 'sn', 'mail')));
define('IMAP_FROM_LDAP_FROM', '#givenname #sn <#mail>');
define('IMAP_FROM_LDAP_FULLNAME', '#givenname #sn');



// Method used for sending mail
// mail => mail() php function
// sendmail => sendmail executable
// smtp => direct connection against SMTP
define('IMAP_SMTP_METHOD', 'smtp');

global $imap_smtp_params;
// SMTP Parameters
//      mail : no params
$imap_smtp_params = array('host' => 'tls://localhost', 'port' => '465', 'auth' => true, 'username' => 'imap_username', 'password' => 'imap_password', 'verify_peer_name' => false, 'verify_peer' => false, 'allow_self_signed' => true);
//      sendmail
//$imap_smtp_params = array('sendmail_path' => '/usr/bin/sendmail', 'sendmail_args' => '-i');
//      smtp
//          "host"              - The server to connect. Default is localhost.
//          "port"              - The port to connect. Default is 25.
//          "auth"              - Whether or not to use SMTP authentication. Default is FALSE.
//          "username"          - The username to use for SMTP authentication. "imap_username" for using the same username as the imap server
//          "password"          - The password to use for SMTP authentication. "imap_password" for using the same password as the imap server
//          "localhost"         - The value to give when sending EHLO or HELO. Default is localhost
//          "timeout"           - The SMTP connection timeout. Default is NULL (no timeout).
//          "verp"              - Whether to use VERP or not. Default is FALSE.
//          "debug"             - Whether to enable SMTP debug mode or not. Default is FALSE.
//          "persist"           - Indicates whether or not the SMTP connection should persist over multiple calls to the send() method.
//          "pipelining"        - Indicates whether or not the SMTP commands pipelining should be used.
//          "verify_peer"       - Require verification of SSL certificate used. Default is TRUE.
//          "verify_peer_name"  - Require verification of peer name. Default is TRUE.
//          "allow_self_signed" - Allow self-signed certificates. Requires verify_peer. Default is FALSE.
//$imap_smtp_params = array('host' => 'localhost', 'port' => 25, 'auth' => false);
// If you want to use SSL with port 25 or port 465 you must preppend "ssl://" before the hostname or IP of your SMTP server
// IMPORTANT: To use SSL you must use PHP 5.1 or later, install openssl libs and use ssl:// within the host variable
// IMPORTANT: To use SSL with PHP 5.6 you should set verify_peer, verify_peer_name and allow_self_signed
//$imap_smtp_params = array('host' => 'ssl://localhost', 'port' => 465, 'auth' => true, 'username' => 'imap_username', 'password' => 'imap_password');



// If you are using IMAP_SMTP_METHOD = mail or sendmail and your sent messages are not correctly displayed you can change this to "\n".
//   BUT, it doesn't comply with RFC 2822 and will break if using smtp method
define('MAIL_MIMEPART_CRLF', "\r\n");


// A file containing file mime types->extension mappings.
//  SELINUX users: make sure the file has a security context accesible by your apache/php-fpm process
define('SYSTEM_MIME_TYPES_MAPPING', '/etc/mime.types');


// Use BackendCalDAV for Meetings. You cannot hope to get that functionality working without a caldav backend.
define('IMAP_MEETING_USE_CALDAV', false);
```

