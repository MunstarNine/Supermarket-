program supermercado;
type
  str=string[30];
  int=integer;
  listaSuper = ^nodoLista;
  productos = record
    codigo:int;
    valor:int;
    nombre:str;
    cantidad:int;
  end;

  nodoLista = record
      productoAgregado:productos;
      siguiente:listaSuper;
  end;

  datosProductos= File of productos;

procedure agregarFinal(var punteroInicial:listaSuper; prod:productos);
var
  nuevoNodo, aux:listaSuper;
  p:productos;
begin
  p:=prod;
  new(nuevoNodo);
  nuevoNodo^.productoAgregado:=p;
  nuevoNodo^.siguiente:=nil;
  if (punteroInicial = nil) then punteroInicial:=nuevoNodo
  else begin
         aux:=punteroInicial;
         while (aux^.siguiente <> nil) do
               aux := aux^.siguiente;
         aux^.siguiente:=nuevoNodo;
         end;

  end;
procedure cargarProductos(var lista:listaSuper);
var
  codigo, valor, cantidad:int;
  nombre:str;
  p:productos;
begin
  readln(p.codigo);
  while (p.codigo <> -1) do begin
    readln(p.valor);
    readln(p.cantidad);
    readln(p.nombre);
    agregarFinal(lista, p);
    writeln('carga finalizada');
    readln(p.codigo);
  end;

end;
procedure recorrerLista(l:listaSuper);
begin
  while (l <> nil) do begin
    writeln(l^.productoAgregado.nombre);
    writeln(l^.productoAgregado.codigo);
    writeln(l^.productoAgregado.valor);
    writeln(l^.productoAgregado.cantidad);
    l:=l^.siguiente;
  end;
end;
procedure recorrerDatos(var data:datosProductos);
var
  p:productos;
begin
  Seek(data,0);
  while not EOF(data) do begin
      Read(data, p);
      writeln(p.nombre,' $',p.valor);

  end;
end;



var
  lista:listaSuper;
  datos:datosProductos;
  i:int;
begin
  Assign(datos,'/productos_disponibles.bin');
  ReSet(datos);

  recorrerDatos(datos);
  lista:=nil;
  cargarProductos(lista);
  recorrerLista(lista);
  readln(i);
end.

