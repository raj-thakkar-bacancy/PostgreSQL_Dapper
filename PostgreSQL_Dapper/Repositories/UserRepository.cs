using Dapper;
using Newtonsoft.Json;
using Npgsql;
using NpgsqlTypes;
using PostgreSQL_Dapper.Helper;
using PostgreSQL_Dapper.Models;
using System.Data;

namespace PostgreSQL_Dapper.Repositories
{
    public class UserRepository
    {
        private readonly string _connectionString;

        public UserRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        private NpgsqlConnection CreateConnection()
        {
            return new NpgsqlConnection(_connectionString);
        }

        public async Task<IEnumerable<User>> Get()
        {
            using (var connection = CreateConnection())
            {
                return await connection.QueryAsync<User>("Select * from get_users()");
            }
        }

        public async Task<User> Get(int id)
        {
            using (var connection = CreateConnection())
            {
                return await connection.QueryFirstOrDefaultAsync<User>("SELECT * FROM User WHERE Id = @Id", new { Id = id });
            }
        }

        public async Task<int> Add(User user)
        {
            using (var connection = CreateConnection())
            {
                var parameters = new DynamicParameters();
                parameters.Add("name", user.Name, DbType.String);
                parameters.Add("email", user.Email, DbType.String);
                parameters.Add("additional_info", new JsonParameter(user.AdditionalInfo.ToString()));
                parameters.Add("new_user_id", 0, DbType.Int32, direction: ParameterDirection.Output);


                await connection.ExecuteAsync(
               "public.add_users", // Fully qualify the procedure name
               parameters,
               commandType: CommandType.StoredProcedure
                );

                return parameters.Get<int>("new_user_id");
            }
        }

        public async Task<int> Update(User user)
        {
            using (var connection = CreateConnection())
            {
                var sql = "UPDATE User SET Name = @Name, Email = @Email WHERE Id = @Id";
                return await connection.ExecuteAsync(sql, user);
            }
        }

        public async Task<int> Delete(int id)
        {
            using (var connection = CreateConnection())
            {
                var sql = "DELETE FROM User WHERE Id = @Id";
                return await connection.ExecuteAsync(sql, new { Id = id });
            }
        }

        public async Task<IEnumerable<User>> GetUsersByDepartment(string department)
        {
            using (var connection = CreateConnection())
            {
                var sql = "Select * from get_users_by_department(@Department)";
                return await connection.QueryAsync<User>(sql, new { Department = department });
            }
        }
    }
}
