import 'package:f_orm_m8/f_orm_m8.dart';

@DataTable("channels")
class Channel implements DbEntity {
  @DataColumn("id",
      metadataLevel: ColumnMetadata.unique |
          ColumnMetadata.autoIncrement |
          ColumnMetadata.primaryKey)
  int id;

  @DataColumn("name", metadataLevel: ColumnMetadata.notNull)
  String name;

  @DataColumn("attending", metadataLevel: ColumnMetadata.notNull)
  bool attending;
}
