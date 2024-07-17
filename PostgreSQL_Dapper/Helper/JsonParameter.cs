using Dapper;
using Npgsql;
using NpgsqlTypes;
using System.Data;

namespace PostgreSQL_Dapper.Helper
{
    public class JsonParameter : SqlMapper.ICustomQueryParameter
    {
        private readonly string _value;

        public JsonParameter(string value)
        {
            _value = value;
        }

        public void AddParameter(IDbCommand command, string name)
        {
            var parameter = new NpgsqlParameter(name, NpgsqlDbType.Json)
            {
                Value = _value
            };

            command.Parameters.Add(parameter);
        }
    }
}
