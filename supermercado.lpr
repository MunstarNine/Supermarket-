program supermercado;
type
  str=string[30];
  int=integer;
  listaSuper = ^nodoLista;
  productos = record
    nombre:str;
    codigo:int;
    valor:int;
    deleted:boolean;
  end;

  nodoLista = record
      productoAgregado:productos;
      valorTotal:int;
      siguiente:listaSuper;
  end;

  datosProductos= File of productos;

procedure agregarFinal(var punteroInicial:listaSuper; prod:productos; cantidad:int);
var
  nuevoNodo, aux:listaSuper;
  p:productos;
begin
  p:=prod;
  new(nuevoNodo);
  nuevoNodo^.productoAgregado:=p;
  nuevoNodo^.valorTotal:=nuevoNodo^.productoAgregado.valor * cantidad;
  nuevoNodo^.siguiente:=nil;
  if (punteroInicial = nil) then punteroInicial:=nuevoNodo
  else begin
         aux:=punteroInicial;
         while (aux^.siguiente <> nil) do
               aux := aux^.siguiente;
         aux^.siguiente:=nuevoNodo;
         end;

  end;
{procedure cargarProductos(var lista:listaSuper; p:productos);
var
  codigo, valor, cantidad:int;
  nombre:str;
begin
  readln(p.codigo);
  while (p.codigo <> -1) do begin
    readln(p.valor);
    readln(p.nombre);
    agregarFinal(lista, p);
    writeln('carga finalizada');
    readln(p.codigo);
  end;

end;
}
procedure recorrerLista(l:listaSuper);
var
  contadorLista, precioTotal:int;
begin
  contadorLista:=0;
  precioTotal:=0;
  writeln('CARRITO:');
  while (l <> nil) do begin
    writeln('');
    writeln(contadorLista,') ',l^.productoAgregado.nombre);
    writeln('Precio unitario: ',l^.productoAgregado.valor);
    writeln('Precio total: ',l^.valorTotal,' (',(l^.valorTotal DIV l^.productoAgregado.valor),')U.');
    writeln('');
    contadorLista:=contadorLista + 1;
    precioTotal:=precioTotal + l^.valorTotal;
    l:=l^.siguiente;
  end;
  writeln('TOTAL: ',precioTotal);
end;
procedure recorrerDatos(var data:datosProductos; p:productos);
begin

  Seek(data,0);
  while not EOF(data) do begin
      Read(data, p);
      writeln((FilePos(data)-1),') -',p.nombre);
      writeln('Precio: $',p.valor);
      writeln('');


  end;
end;
procedure buscarProducto(var data:datosProductos; var p:productos; busqueda:int);
begin
  Seek(data, busqueda);
  Read(data, p);
end;

var
  lista:listaSuper;
  datos:datosProductos;
  p:productos;
  seleccion1, seleccion2:int;
begin
  Assign(datos,'productos_disponibles.bin');
  Reset(datos);
  lista:=nil;
  writeln('Bienvenido! que desea hacer? (ingrese 4 para salir):');
  repeat
  writeln('');
  writeln('1- Comprar.');
  writeln('2- Ver el carrito.');
  writeln('3- Eliminar producto.');
  writeln('4- Salir.');
  readln(seleccion1);
  case seleccion1 of
    1:begin
        repeat
         writeln('');
         writeln('Que desea comprar? para volver al menu anterior ingrese -1');
         writeln('');
         recorrerDatos(datos, p);
         readln(seleccion2);
         if (seleccion2 <> -1) then begin
         buscarProducto(datos,p,seleccion2);
         writeln('Cuanto(s) ',p.nombre,' desea comprar?');
         readln(seleccion2);
         agregarFinal(lista, p, seleccion2);
         writeln('');
         writeln(seleccion2,' ',p.nombre,' agregado al carrito.');
         writeln('');
         end;
         until (seleccion2 = -1);
      end;
    2:begin
        writeln('');
        if (lista = nil) then writeln('Carrito vacio')
        else
         recorrerLista(lista);
        writeln('');
      end;
    3:begin

        writeln('');
        writeln('WIP!');
        writeln('');

      end;
    end;

until seleccion1 = 4;
end.

