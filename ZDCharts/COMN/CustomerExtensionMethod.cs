using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace COMN
{
    public static class CustomerExtensionMethod
    {
        public static IQueryable<T> OrderByPropertName<T>(this IQueryable<T> queryable, string propertyName)
            {
                return OrderByPropertName(queryable, propertyName, false);
            }
            public static IQueryable<T> OrderByPropertName<T>(this IQueryable<T> queryable, string propertyName, bool desc)
            {
                var param = Expression.Parameter(typeof(T));
                var body = Expression.Property(param, propertyName);
                dynamic keySelector = Expression.Lambda(body, param);
                return desc ? Queryable.OrderByDescending(queryable, keySelector) : Queryable.OrderBy(queryable, keySelector);
            }
        }
    
}
