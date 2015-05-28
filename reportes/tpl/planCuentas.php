<?php  
  $cabecera = $dataSource->getParameter('cabecera');
?>
<html>
	 <head></head>
<body>
	
	
	<?php  //var_dump($cabecera); ?> 
	<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	  <tr> 
	  	 <td width="40%"><b>Código</b></td>
	  	 <td width="60%"><b>Cuenta</b></td>
	  </tr>
	  <?php 
		   foreach($cabecera as $key=>$val){     ?>
	  <tr> 
	  	 <td width="40%"><?php  echo '1111111111111111111111<br>'; ?></td>
	  	 <td width="60%"><?php  //echo $val['nombre_cuenta']; ?></td>
	  </tr>
	  
	 <?php } ?>
	</table>
	

</body>
</html>