
#include <stdint.h>

extern void binio_fopen(      int*  unit      ,
                              int*  stat      ,
                        const char* file      ,
                              int*  filelen   ,
                        const char* action    ,
                        const long long*  recl,
                        const char* endian    );


extern void binio_fclose(const int* unit);


extern void binio_fread_i2(const int*   unit        ,
                           const long long* n       ,
                           const long long* record  ,
                                 int16_t* input_data,
                                 int*   stat        );

extern void binio_fread_i4(const int*   unit        ,
                           const long long* n       ,
                           const long long* record  ,
                                 int32_t* input_data,
                                 int*   stat        );

extern void binio_fread_i8(const int*   unit        ,
                           const long long* n       ,
                           const long long* record  ,
                                 int64_t* input_data,
                                 int*   stat        );

extern void binio_fread_sp(const int*   unit      ,
                           const long long* n     ,
                           const long long* record,
                                 float* input_data,
                                 int*   stat      );

extern void binio_fread_dp(const int*    unit      ,
                           const long long* n      ,
                           const long long* record ,
                                 double* input_data,
                                 int*    stat      );

extern void binio_fwrite_i2(const int*   unit         ,
                            const long long* n        ,
                            const long long* record   ,
                                  int16_t* output_data,
                                  int*   stat         );

extern void binio_fwrite_i4(const int*   unit         ,
                            const long long* n        ,
                            const long long* record   ,
                                  int32_t* output_data,
                                  int*   stat         );

extern void binio_fwrite_i8(const int*   unit         ,
                            const long long* n        ,
                            const long long* record   ,
                                  int64_t* output_data,
                                  int*   stat         );

extern void binio_fwrite_sp(const int*   unit       ,
                            const long long* n      ,
                            const long long* record ,
                                  float* output_data,
                                  int*   stat       );

extern void binio_fwrite_dp(const int*    unit       ,
                            const long long* n       ,
                            const long long* record  ,
                                  double* output_data,
                                  int*    stat       );


