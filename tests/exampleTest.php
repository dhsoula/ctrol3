<?php
// Inclure le fichier contenant la fonction helloWorld()
include_once 'src/example.php';

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase {
    public function testHelloWorld() {
        $this->assertEquals("Hello, World!", helloWorld());
    }
}

