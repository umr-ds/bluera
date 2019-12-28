import 'package:f_orm_m8/f_orm_m8.dart';

@DataTable("settings")
class Settings implements DbEntity {
  @DataColumn("id",
      metadataLevel: ColumnMetadata.unique |
          ColumnMetadata.autoIncrement |
          ColumnMetadata.primaryKey)
  int id;

  @DataColumn("user", metadataLevel: ColumnMetadata.notNull)
  String user;
}
