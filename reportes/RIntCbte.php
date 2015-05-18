<?php
class CustomReportTemplate{
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header() {
        
    } 
	
	 
    
}


Class RSolicitudCompra extends CustomReportTemplate {
	var $objParam;
	function __construct(CTParametro $objParam) {
		$this->objParam = $objParam;
	}
    
    function write() {
    	
        
    }
   
        
}
?>