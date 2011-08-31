<?php
header("Content-type: text/plain");

/**
 * Ensure some condition is met, raise error if not.
 */
function ensure($condition, $error_message) {
    if (!$condition) {
        $e = new Exception($error_message);
        throw $e;
    }
}

class Application {
    /**
     * List of resources and available methods exposed by this application
     */
    var $resources = array(
        'index' => array(
            'GET' => 'index'
        ),
        'happiness' => array(
            'POST' => 'add_happiness'
        )
    );
    
    var $args = null;
    
    function not_found() {
        header("HTTP/1.0 404 Not Found");
        echo "Not Found\n";
        exit();
    }
    
    function bad_request($err=null) {
        header("HTTP/1.0 400 Bad Request");
        echo "Bad Request\n";
        if (is_object($err) && method_exists($err, 'getMessage')) {
            echo $err->getMessage() . "\n";
        }
        exit();
    }
    
    function method_not_allowed() {
        header("HTTP/1.0 405 Method Not Allowed");
        echo "Method Not Allowed\n";
        exit();
    }
    
    function internal_server_error($err=null) {
        header("HTTP/1.0 500 Internal Server Error");
        echo "Internal Server Error\n";
        if (is_object($err) && method_exists($err, 'getMessage')) {
            echo $err->getMessage() . "\n";
        }
        exit();
    }
    
    function redirect($location='/') {
        header("Location: " . $location);
        exit();
    }
    
    function run() {
        $this->args = explode('/', array_key_exists('PATH_INFO', $_SERVER) ? $_SERVER['PATH_INFO'] : array());
        array_shift($this->args);
        $resource = array_shift($this->args);    
        $resource = $resource ? $resource : 'index';
        
        if (!array_key_exists($resource, $this->resources)) {
            $this->not_found();
        }
        
        if (!array_key_exists($_SERVER['REQUEST_METHOD'], $this->resources[$resource])) {
            $this->method_not_allowed();
        }
        
        try {
            call_user_func(array(&$this, $this->resources[$resource][$_SERVER['REQUEST_METHOD']]));
        } catch (Exception $e) {
            $this->internal_server_error($e);
        }
    }
    
    private function index() {
        echo "Hello world\n";
    }
    
    private function add_happiness() {
        try {
            // Save happiness data...
            // We expect:
            // _ location (INT)
            // _ happiness (INT)
            // _ unhappiness (INT)
            ensure(array_key_exists('location', $_POST), 'Location required');
            ensure(array_key_exists('happiness', $_POST), 'Happiness required');
            ensure(array_key_exists('unhappiness', $_POST), 'Unhappiness required');    
            list($location, $happiness, $unhappiness) = array(
                intval($_POST['location']),
                intval($_POST['happiness']),
                intval($_POST['unhappiness'])
            );
        } catch (Exception $e) {
            $this->bad_request($e);
        }
        
        // http://uk2.php.net/manual/en/sqlite3.open.php
        $db = new SQLite3('./happy-balls.db', SQLITE3_OPEN_READWRITE);
        $sql = sprintf('INSERT INTO happiness(location, happiness, unhappiness) VALUES (%d, %d, %d);', $location, $happiness, $unhappiness);
        $db->exec($sql);
        $id = $db->lastInsertRowID();
        $db->close();
        
        print("OK, id=$id\n");
    }    
}

$app = new Application();
$app->run();

?>
