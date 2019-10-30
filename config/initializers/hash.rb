# https://github.com/rails/rails/issues/25010
# came across when trying to get page resource role access scopes working
class Hash
  undef_method :to_proc if self.method_defined?(:to_proc)
end