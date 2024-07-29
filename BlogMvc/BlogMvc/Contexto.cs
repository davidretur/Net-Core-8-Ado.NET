namespace BlogMvc
{
    public class Contexto
    {
        // creamos la variable de tipo conexion que hace referencia a la conexion db
        public string conexion { get;}
        // generamos un cosntructor para iniciar la conexion db
        public Contexto(string valor)
        {
            conexion = valor;
        }
    }
}
